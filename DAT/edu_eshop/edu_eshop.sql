-- ============================================================================
-- Výuková databáze: edu_eshop
-- Předmět: Databázové systémy (DAT10, DAT20, DAT30)
-- Účel: Komplexní demonstrace DDL, DML, DQL, integritních omezení,
--       vazeb 1:1, 1:N, M:N, sebereference, triggerů, pohledů a JSON typu.
-- Kompatibilita: MySQL 8.0+ / MariaDB 10.5+
-- ============================================================================

DROP DATABASE IF EXISTS `edu_eshop`;
CREATE DATABASE `edu_eshop` CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
USE `edu_eshop`;

-- ============================================================================
-- 1. STRUKTURA TABULEK (DDL)
-- ============================================================================

-- Tabulka: customer (Zákaznický účet / autentizace)
CREATE TABLE `customer` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `email` varchar(100) NOT NULL UNIQUE,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` boolean NOT NULL DEFAULT true
) ENGINE=InnoDB;

-- Tabulka: customer_profile (Osobní profil zákazníka - Vztah 1:1 k tabulce customer)
CREATE TABLE `customer_profile` (
  `customer_id` int PRIMARY KEY,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL
) ENGINE=InnoDB;

-- Tabulka: category (Kategorie produktů - Sebereferenční stromová hierarchie 1:N)
CREATE TABLE `category` (
  `id` smallint PRIMARY KEY AUTO_INCREMENT,
  `parent_id` smallint DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `product_count` mediumint NOT NULL DEFAULT 0 COMMENT 'Denormalizovaný agregát udržovaný přes TRIGGER'
) ENGINE=InnoDB;

-- Tabulka: product (Katalog produktů s podporou JSON atributů)
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

-- Tabulka: product_category (Vazební tabulka pro dekompozici M:N vazby)
CREATE TABLE `product_category` (
  `product_id` int NOT NULL,
  `category_id` smallint NOT NULL,
  PRIMARY KEY (`product_id`, `category_id`)
) ENGINE=InnoDB;

-- Tabulka: rating (Zákaznická hodnocení a recenze - Vztah 1:N)
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

-- Tabulka: orders (Objednávky / nákupní košíky)
CREATE TABLE `orders` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `status` ENUM ('new', 'paid', 'shipped', 'cancelled') NOT NULL DEFAULT 'new',
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `chk_orders_total_price` CHECK (`total_price` >= 0)
) ENGINE=InnoDB;

-- Tabulka: order_item (Položky objednávky - Dekompozice M:N s historickou cenou)
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

-- ============================================================================
-- 5. TESTOVACÍ DATA (SEED DATA)
-- ============================================================================

-- Zákazníci (hesla jsou ukázkové hashe)
INSERT INTO `customer` (`id`, `email`, `password_hash`, `created_at`, `active`) VALUES
(1, 'jan.novak@email.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopq', '2025-01-10 10:15:00', true),
(2, 'petra.svobodova@seznam.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopr', '2025-01-12 14:22:00', true),
(3, 'tomas.dvorak@gmail.com', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnops', '2025-02-01 09:00:00', true),
(4, 'lucie.cerna@post.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopt', '2025-02-15 18:45:00', false);

-- Profily zákazníků (1:1 k účtům)
INSERT INTO `customer_profile` (`customer_id`, `first_name`, `last_name`, `phone`, `birth_date`) VALUES
(1, 'Jan', 'Novák', '+420 777 123 456', '1988-04-12'),
(2, 'Petra', 'Svobodová', '+420 608 987 654', '1995-11-28'),
(3, 'Tomáš', 'Dvořák', '+420 721 333 444', '2001-07-03');
-- Zákazník 4 profil zatím nevyplnil (pro demonstraci LEFT JOIN / NULL)

-- Hierarchie kategorií (sebereference)
INSERT INTO `category` (`id`, `parent_id`, `name`, `description`, `product_count`) VALUES
(1, NULL, 'Elektronika', 'Veškerá spotřební a výpočetní elektronika', 0),
(2, 1, 'Mobilní telefony', 'Chytré i tlačítkové telefony', 0),
(3, 1, 'Počítače a notebooky', 'Stolní PC, notebooky a příslušenství', 0),
(4, 3, 'Příslušenství', 'Klávesnice, myši, kabely a adaptéry', 0),
(5, NULL, 'Domácnost a zahrada', 'Vybavení pro dům i zahradu', 0);

-- Produkty (včetně JSON atributů)
INSERT INTO `product` (`id`, `name`, `price`, `stock_quantity`, `attributes`, `description`, `created_at`, `active`) VALUES
(1, 'Smartphone Galaxy X', 14999.00, 25, '{"color": "Black", "ram_gb": 8, "storage_gb": 256, "5g": true}', 'Výkonný smartphone s OLED displejem.', '2025-01-01 12:00:00', true),
(2, 'Laptop Pro 15', 28990.00, 10, '{"color": "Silver", "cpu": "Intel i7", "ram_gb": 16, "ssd_gb": 512}', 'Profesionální notebook pro práci i multimédia.', '2025-01-05 08:30:00', true),
(3, 'Bezdrátová optická myš', 499.00, 150, '{"color": "Black", "connection": "Wireless 2.4GHz", "dpi": 1600}', 'Ergonomická bezdrátová myš s tichým klikáním.', '2025-01-10 16:00:00', true),
(4, 'Mechanická herní klávesnice', 1890.00, 40, '{"color": "RGB", "switches": "Cherry MX Red", "layout": "CZ"}', 'Mechanická herní klávesnice s podsvícením.', '2025-01-15 11:20:00', true),
(5, 'Ochranné pouzdro na telefon', 299.00, 80, '{"color": "Transparent", "material": "Silicone"}', 'Silikonové nárazuvzdorné pouzdro.', '2025-01-20 14:00:00', true),
(6, 'Starý model tiskárny', 1200.00, 0, '{"type": "Inkjet"}', 'Již neprodávaný model tiskárny.', '2024-05-10 10:00:00', false);

-- Zařazení produktů do kategorií (M:N)
-- Vložení automaticky aktivuje trigger trg_category_product_count_insert!
INSERT INTO `product_category` (`product_id`, `category_id`) VALUES
(1, 1), -- Mobil je v Elektronice
(1, 2), -- Mobil je v Mobilních telefonech
(2, 1), -- Laptop je v Elektronice
(2, 3), -- Laptop je v Počítačích a noteboocích
(3, 1), -- Myš je v Elektronice
(3, 4), -- Myš je v Příslušenství
(4, 1), -- Klávesnice je v Elektronice
(4, 4), -- Klávesnice je v Příslušenství
(5, 2); -- Pouzdro je v Mobilních telefonech

-- Hodnocení produktů
INSERT INTO `rating` (`product_id`, `customer_id`, `score`, `comment`, `created_at`) VALUES
(1, 1, 5, 'Skvělý telefon, rychlé reakce i fotoaparát.', '2025-01-15 14:00:00'),
(1, 2, 4, 'Baterie by mohla vydržet o něco déle, jinak super.', '2025-01-20 19:30:00'),
(3, 1, 4, 'Příjemná do ruky, dobrý dosah.', '2025-01-25 10:10:00'),
(4, 3, 5, 'Nejlepší klávesnice, co jsem kdy měl!', '2025-02-10 11:00:00');

-- Objednávky
INSERT INTO `orders` (`id`, `customer_id`, `status`, `total_price`, `created_at`) VALUES
(1, 1, 'shipped', 0.00, '2025-01-15 13:30:00'),
(2, 2, 'paid', 0.00, '2025-01-22 17:15:00'),
(3, 3, 'new', 0.00, '2025-02-12 08:45:00');

-- Položky objednávky
-- Vložení automaticky aktivuje trigger trg_order_item_after_insert a přepočítá total_price v orders!
INSERT INTO `order_item` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 1, 14999.00),
(1, 3, 1, 499.00),
(2, 2, 1, 28990.00),
(2, 5, 2, 299.00),
(3, 4, 1, 1890.00);

-- ============================================================================
-- KONEC SKRIPTU
-- ============================================================================
