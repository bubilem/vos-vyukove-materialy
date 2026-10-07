-- ============================================================================
-- Výuková databáze: edu_eshop (DEMO DATA / TESTOVACÍ DATA)
-- Předmět: Databázové systémy (DAT10, DAT20, DAT30) - VOŠ a SPŠ
-- Účel: Naplnění databáze realistickými vzorovými daty pro testování
--       dotazů, spojování tabulek (JOIN), agregací, pohledů a triggerů.
-- Kompatibilita: MySQL 8.0+ / MariaDB 10.5+
-- ============================================================================

USE `edu_eshop`;

-- Dočasné vypnutí kontroly cizích klíčů pro bezpečné čištění a seedování
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `order_item`;
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `rating`;
TRUNCATE TABLE `product_category`;
TRUNCATE TABLE `product`;
TRUNCATE TABLE `category`;
TRUNCATE TABLE `customer_profile`;
TRUNCATE TABLE `customer`;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- 1. ZÁKAZNÍCI (customer)
-- ============================================================================
-- Demonstruje aktivní/neaktivní uživatele a unikátnost e-mailů.
INSERT INTO `customer` (`id`, `email`, `password_hash`, `created_at`, `active`) VALUES
(1, 'jan.novak@email.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopq', '2025-01-10 10:15:00', true),
(2, 'petra.svobodova@seznam.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopr', '2025-01-12 14:22:00', true),
(3, 'tomas.dvorak@gmail.com', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnops', '2025-02-01 09:00:00', true),
(4, 'lucie.cerna@post.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopt', '2025-02-15 18:45:00', false),
(5, 'martin.kriz@centrum.cz', '$2y$10$abcdefghijklmnopqrstuv1234567890abcdefghijklmnopu', '2025-02-20 11:10:00', true);

-- ============================================================================
-- 2. OSOBNÍ PROFILY ZÁKAZNÍKŮ (customer_profile - Vazba 1:1)
-- ============================================================================
-- Všimněte si:
-- - Zákazník 4 profil nemá (vhodné pro demonstraci LEFT JOIN vs INNER JOIN).
-- - Zákazník 5 profil má, ale zatím nevytvořil žádnou objednávku.
INSERT INTO `customer_profile` (`customer_id`, `first_name`, `last_name`, `phone`, `birth_date`) VALUES
(1, 'Jan', 'Novák', '+420 777 123 456', '1988-04-12'),
(2, 'Petra', 'Svobodová', '+420 608 987 654', '1995-11-28'),
(3, 'Tomáš', 'Dvořák', '+420 721 333 444', '2001-07-03'),
(5, 'Martin', 'Kříž', '+420 732 111 222', '1992-09-15');

-- ============================================================================
-- 3. KATEGORIE PRODUKTŮ (category - Stromová hierarchie 1:N)
-- ============================================================================
-- Počítadlo product_count je inicializováno na 0, následný INSERT do
-- product_category jej automaticky zvýší přes TRIGGER.
-- Kategorie 5 (Domácnost a zahrada) záměrně nemá žádný produkt (test prázdných kategorií).
INSERT INTO `category` (`id`, `parent_id`, `name`, `description`, `product_count`) VALUES
(1, NULL, 'Elektronika', 'Veškerá spotřební a výpočetní elektronika', 0),
(2, 1, 'Mobilní telefony', 'Chytré i tlačítkové telefony', 0),
(3, 1, 'Počítače a notebooky', 'Stolní PC, notebooky a příslušenství', 0),
(4, 3, 'Příslušenství', 'Klávesnice, myši, kabely a adaptéry', 0),
(5, NULL, 'Domácnost a zahrada', 'Vybavení pro dům i zahradu', 0);

-- ============================================================================
-- 4. PRODUKTY (product - Relační data + NoSQL JSON atributy)
-- ============================================================================
-- Všimněte si:
-- - Produkt 6 má stock_quantity = 0 a active = false (vyřazené zboží).
-- - Sloupec attributes obsahuje validní JSON dokumenty různých struktur.
INSERT INTO `product` (`id`, `name`, `price`, `stock_quantity`, `attributes`, `description`, `created_at`, `active`) VALUES
(1, 'Smartphone Galaxy X', 14999.00, 25, '{"color": "Black", "ram_gb": 8, "storage_gb": 256, "5g": true}', 'Výkonný smartphone s OLED displejem.', '2025-01-01 12:00:00', true),
(2, 'Laptop Pro 15', 28990.00, 10, '{"color": "Silver", "cpu": "Intel i7", "ram_gb": 16, "ssd_gb": 512}', 'Profesionální notebook pro práci i multimédia.', '2025-01-05 08:30:00', true),
(3, 'Bezdrátová optická myš', 499.00, 150, '{"color": "Black", "connection": "Wireless 2.4GHz", "dpi": 1600}', 'Ergonomická bezdrátová myš s tichým klikáním.', '2025-01-10 16:00:00', true),
(4, 'Mechanická herní klávesnice', 1890.00, 40, '{"color": "RGB", "switches": "Cherry MX Red", "layout": "CZ"}', 'Mechanická herní klávesnice s podsvícením.', '2025-01-15 11:20:00', true),
(5, 'Ochranné pouzdro na telefon', 299.00, 80, '{"color": "Transparent", "material": "Silicone"}', 'Silikonové nárazuvzdorné pouzdro.', '2025-01-20 14:00:00', true),
(6, 'Starý model tiskárny', 1200.00, 0, '{"type": "Inkjet"}', 'Již neprodávaný model tiskárny.', '2024-05-10 10:00:00', false),
(7, 'USB-C nabíjecí kabel 2m', 199.00, 200, '{"color": "White", "length_m": 2, "fast_charge": true}', 'Odolný opletený kabel s podporou rychlonabíjení.', '2025-01-22 09:15:00', true);

-- ============================================================================
-- 5. ZAŘAZENÍ PRODUKTŮ DO KATEGORIÍ (product_category - Vazba M:N)
-- ============================================================================
-- Vložení automaticky aktivuje trigger trg_category_product_count_insert!
-- Produkt 6 schválně není zařazen do žádné kategorie (test produktů bez vazby).
INSERT INTO `product_category` (`product_id`, `category_id`) VALUES
(1, 1), -- Mobil je v Elektronice
(1, 2), -- Mobil je v Mobilních telefonech
(2, 1), -- Laptop je v Elektronice
(2, 3), -- Laptop je v Počítačích a noteboocích
(3, 1), -- Myš je v Elektronice
(3, 4), -- Myš je v Příslušenství
(4, 1), -- Klávesnice je v Elektronice
(4, 4), -- Klávesnice je v Příslušenství
(5, 2), -- Pouzdro je v Mobilních telefonech
(7, 1), -- Kabel je v Elektronice
(7, 4); -- Kabel je v Příslušenství

-- ============================================================================
-- 6. HODNOCENÍ PRODUKTŮ (rating - Vazba 1:N)
-- ============================================================================
-- Zákazník smí hodnotit produkt maximálně jednou (UNIQUE customer_id + product_id).
-- Produkty 2 a 6 zatím recenze nemají (vhodné pro COALESCE / LEFT JOIN).
INSERT INTO `rating` (`product_id`, `customer_id`, `score`, `comment`, `created_at`) VALUES
(1, 1, 5, 'Skvělý telefon, rychlé reakce i fotoaparát.', '2025-01-15 14:00:00'),
(1, 2, 4, 'Baterie by mohla vydržet o něco déle, jinak super.', '2025-01-20 19:30:00'),
(3, 1, 4, 'Příjemná do ruky, dobrý dosah.', '2025-01-25 10:10:00'),
(4, 3, 5, 'Nejlepší klávesnice, co jsem kdy měl!', '2025-02-10 11:00:00'),
(7, 2, 5, 'Rychlé nabíjení funguje bez problémů, kvalitní oplet.', '2025-02-18 15:40:00');

-- ============================================================================
-- 7. OBJEDNÁVKY (orders)
-- ============================================================================
-- Zastoupeny jsou všechny stavy ENUM: new, paid, shipped, cancelled.
-- Celková cena total_price se po vložení položek automaticky aktualizuje triggerem.
INSERT INTO `orders` (`id`, `customer_id`, `status`, `total_price`, `created_at`) VALUES
(1, 1, 'shipped', 0.00, '2025-01-15 13:30:00'),
(2, 2, 'paid', 0.00, '2025-01-22 17:15:00'),
(3, 3, 'new', 0.00, '2025-02-12 08:45:00'),
(4, 1, 'cancelled', 0.00, '2025-02-14 16:00:00');

-- ============================================================================
-- 8. POLOŽKY OBJEDNÁVKY (order_item - Vazba M:N s historickou cenou)
-- ============================================================================
-- Vložení automaticky aktivuje trigger trg_order_item_after_insert a dopočítá total_price v orders:
-- Objednávka 1: 14999 + 499 = 15498.00 Kč
-- Objednávka 2: 28990 + (2 * 299) + 199 = 29787.00 Kč
-- Objednávka 3: 1890 + (2 * 199) = 2288.00 Kč
-- Objednávka 4: 28990.00 Kč
INSERT INTO `order_item` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 1, 14999.00),
(1, 3, 1, 499.00),
(2, 2, 1, 28990.00),
(2, 5, 2, 299.00),
(2, 7, 1, 199.00),
(3, 4, 1, 1890.00),
(3, 7, 2, 199.00),
(4, 2, 1, 28990.00);

-- ============================================================================
-- KONTROLNÍ DOTAZY PRO OVĚŘENÍ SPRÁVNOSTI IMPORTU:
-- ============================================================================
-- SELECT * FROM v_product_catalog;
-- SELECT * FROM v_order_summary;
-- SELECT id, name, product_count FROM category;
-- SELECT id, status, total_price FROM orders;
