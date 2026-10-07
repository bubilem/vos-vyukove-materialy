-- ============================================================================
-- Výuková databáze: edu_eshop (STRUKTURA A DDL DEFINICE)
-- Předmět: Databázové systémy (DAT10, DAT20, DAT30) - VOŠ a SPŠ
-- Účel: Definice databázového schématu, tabulek, integritních omezení,
--       vazeb 1:1, 1:N, M:N, sebereference, triggerů a pohledů (VIEW).
-- Kompatibilita: MySQL 8.0+ / MariaDB 10.5+
-- Kódování: UTF-8 (utf8mb4_czech_ci)
-- ============================================================================

DROP DATABASE IF EXISTS `edu_eshop`;
CREATE DATABASE `edu_eshop` CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
USE `edu_eshop`;

-- ============================================================================
-- 1. STRUKTURA TABULEK (DDL)
-- ============================================================================

-- Tabulka 1: customer (Zákaznický účet / autentizace)
CREATE TABLE `customer` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `email` varchar(100) NOT NULL UNIQUE,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` boolean NOT NULL DEFAULT true
) ENGINE=InnoDB;

-- Tabulka 2: customer_profile (Osobní profil zákazníka - Vztah 1:1 k tabulce customer)
CREATE TABLE `customer_profile` (
  `customer_id` int PRIMARY KEY,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL
) ENGINE=InnoDB;

-- Tabulka 3: category (Kategorie produktů - Sebereferenční stromová hierarchie 1:N)
CREATE TABLE `category` (
  `id` smallint PRIMARY KEY AUTO_INCREMENT,
  `parent_id` smallint DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `product_count` mediumint NOT NULL DEFAULT 0 COMMENT 'Denormalizovaný agregát udržovaný přes TRIGGER'
) ENGINE=InnoDB;

-- Tabulka 4: product (Katalog produktů s podporou JSON atributů)
CREATE TABLE `product` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL DEFAULT 0,
  `attributes` json DEFAULT NULL COMMENT 'Flexibilní nestrukturované parametry produktu',
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` boolean NOT NULL DEFAULT true,
  CONSTRAINT `chk_product_price` CHECK (`price` >= 0),
  CONSTRAINT `chk_product_stock` CHECK (`stock_quantity` >= 0)
) ENGINE=InnoDB;

-- Tabulka 5: product_category (Vazební tabulka pro dekompozici M:N vazby)
CREATE TABLE `product_category` (
  `product_id` int NOT NULL,
  `category_id` smallint NOT NULL,
  PRIMARY KEY (`product_id`, `category_id`)
) ENGINE=InnoDB;

-- Tabulka 6: rating (Zákaznická hodnocení a recenze - Vztah 1:N)
CREATE TABLE `rating` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `score` tinyint NOT NULL COMMENT 'Hodnocení 1 až 5 hvězdiček',
  `comment` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `chk_rating_score` CHECK (`score` BETWEEN 1 AND 5),
  CONSTRAINT `uq_customer_product_rating` UNIQUE (`customer_id`, `product_id`)
) ENGINE=InnoDB;

-- Tabulka 7: orders (Objednávky / nákupní košíky)
CREATE TABLE `orders` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `status` ENUM ('new', 'paid', 'shipped', 'cancelled') NOT NULL DEFAULT 'new',
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `chk_orders_total_price` CHECK (`total_price` >= 0)
) ENGINE=InnoDB;

-- Tabulka 8: order_item (Položky objednávky - Dekompozice M:N s historickou cenou)
CREATE TABLE `order_item` (
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` smallint NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL COMMENT 'Historická prodejní cena v době objednání',
  PRIMARY KEY (`order_id`, `product_id`),
  CONSTRAINT `chk_order_item_quantity` CHECK (`quantity` > 0),
  CONSTRAINT `chk_order_item_unit_price` CHECK (`unit_price` >= 0)
) ENGINE=InnoDB;

-- ============================================================================
-- 2. CIZÍ KLÍČE A REFERENČNÍ INTEGRITA (ALTER TABLE)
-- ============================================================================

-- 1:1 - Smazáním zákazníka zaniká i jeho profil
ALTER TABLE `customer_profile`
  ADD CONSTRAINT `fk_customer_profile_customer`
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Sebereference - Smazáním nadřazené kategorie se podkategorie stanou kořenovými (SET NULL)
ALTER TABLE `category`
  ADD CONSTRAINT `fk_category_parent`
  FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`)
  ON DELETE SET NULL ON UPDATE CASCADE;

-- Vazební tabulka produktů a kategorií - Kaskádové mazání vazby při zániku produktu či kategorie
ALTER TABLE `product_category`
  ADD CONSTRAINT `fk_product_category_product`
  FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_category_category`
  FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Recenze - Smazáním produktu či zákazníka se smažou i recenze
ALTER TABLE `rating`
  ADD CONSTRAINT `fk_rating_product`
  FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rating_customer`
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Objednávky - RESTRICT: Zákazníka s existujícími objednávkami nelze smazat (účetní ochrana)
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customer`
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

-- Položky objednávky:
-- Smazáním objednávky se kaskádově smažou její položky (CASCADE)
-- Produkt figurující v realizované objednávce nelze z DB natvrdo smazat (RESTRICT)
ALTER TABLE `order_item`
  ADD CONSTRAINT `fk_order_item_order`
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_item_product`
  FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

-- ============================================================================
-- 3. PROGRAMOVATELNÉ OBJEKTY: TRIGGERY (Spouště)
-- ============================================================================

DELIMITER $$

-- Trigger 1: Inkrementace počítadla produktů v kategorii po vložení vazby
CREATE TRIGGER `trg_category_product_count_insert`
AFTER INSERT ON `product_category`
FOR EACH ROW
BEGIN
  UPDATE `category`
  SET `product_count` = `product_count` + 1
  WHERE `id` = NEW.`category_id`;
END$$

-- Trigger 2: Dekrementace počítadla produktů v kategorii po smazání vazby
CREATE TRIGGER `trg_category_product_count_delete`
AFTER DELETE ON `product_category`
FOR EACH ROW
BEGIN
  UPDATE `category`
  SET `product_count` = GREATEST(0, `product_count` - 1)
  WHERE `id` = OLD.`category_id`;
END$$

-- Trigger 3: Aktualizace počítadel při změně zařazení do kategorie
CREATE TRIGGER `trg_category_product_count_update`
AFTER UPDATE ON `product_category`
FOR EACH ROW
BEGIN
  IF OLD.`category_id` != NEW.`category_id` THEN
    UPDATE `category` SET `product_count` = GREATEST(0, `product_count` - 1) WHERE `id` = OLD.`category_id`;
    UPDATE `category` SET `product_count` = `product_count` + 1 WHERE `id` = NEW.`category_id`;
  END IF;
END$$

-- Trigger 4: Automatický přepočet celkové ceny objednávky při vložení položky
CREATE TRIGGER `trg_order_item_after_insert`
AFTER INSERT ON `order_item`
FOR EACH ROW
BEGIN
  UPDATE `orders`
  SET `total_price` = (
    SELECT COALESCE(SUM(`quantity` * `unit_price`), 0)
    FROM `order_item`
    WHERE `order_id` = NEW.`order_id`
  )
  WHERE `id` = NEW.`order_id`;
END$$

-- Trigger 5: Automatický přepočet celkové ceny objednávky při úpravě položky
CREATE TRIGGER `trg_order_item_after_update`
AFTER UPDATE ON `order_item`
FOR EACH ROW
BEGIN
  UPDATE `orders`
  SET `total_price` = (
    SELECT COALESCE(SUM(`quantity` * `unit_price`), 0)
    FROM `order_item`
    WHERE `order_id` = NEW.`order_id`
  )
  WHERE `id` = NEW.`order_id`;
END$$

-- Trigger 6: Automatický přepočet celkové ceny objednávky po smazání položky
CREATE TRIGGER `trg_order_item_after_delete`
AFTER DELETE ON `order_item`
FOR EACH ROW
BEGIN
  UPDATE `orders`
  SET `total_price` = (
    SELECT COALESCE(SUM(`quantity` * `unit_price`), 0)
    FROM `order_item`
    WHERE `order_id` = OLD.`order_id`
  )
  WHERE `id` = OLD.`order_id`;
END$$

DELIMITER ;

-- ============================================================================
-- 4. POHLEDY (VIEWS) PRO VÝUKU A REPORTING
-- ============================================================================

-- Pohled 1: Přehled katalogu produktů včetně kategorií a průměrného hodnocení
CREATE OR REPLACE VIEW `v_product_catalog` AS
SELECT 
  p.id AS product_id,
  p.name AS product_name,
  p.price,
  p.stock_quantity,
  p.active,
  GROUP_CONCAT(DISTINCT c.name ORDER BY c.name SEPARATOR ', ') AS categories,
  ROUND(AVG(r.score), 2) AS average_rating,
  COUNT(DISTINCT r.id) AS rating_count
FROM `product` p
LEFT JOIN `product_category` pc ON p.id = pc.product_id
LEFT JOIN `category` c ON pc.category_id = c.id
LEFT JOIN `rating` r ON p.id = r.product_id
GROUP BY p.id, p.name, p.price, p.stock_quantity, p.active;

-- Pohled 2: Souhrnný report objednávek se jmény zákazníků a počty položek
CREATE OR REPLACE VIEW `v_order_summary` AS
SELECT 
  o.id AS order_id,
  o.created_at,
  o.status,
  c.id AS customer_id,
  c.email,
  CONCAT(cp.first_name, ' ', cp.last_name) AS customer_name,
  cp.phone,
  COUNT(oi.product_id) AS total_distinct_items,
  COALESCE(SUM(oi.quantity), 0) AS total_items_count,
  o.total_price
FROM `orders` o
JOIN `customer` c ON o.customer_id = c.id
LEFT JOIN `customer_profile` cp ON c.id = cp.customer_id
LEFT JOIN `order_item` oi ON o.id = oi.order_id
GROUP BY o.id, o.created_at, o.status, c.id, c.email, cp.first_name, cp.last_name, cp.phone, o.total_price;
