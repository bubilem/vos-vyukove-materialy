# Databázové systémy

## Cíl předmětu
Cílem předmětu je studenta seznámit s kompletním postupem návrhu, tvorby a implementace databáze. Student se seznámí a vyzkouší si každý krok postupu realizace databáze a bude jej umět zdokumentovat. Velmi důkladně se naučí pracovat s relační databází a základy jazyka SQL. Seznámí se se systémy řízení bází dat a bude na nich umět databáze spravovat.

## Anotace předmětu
Předmět Databázové systémy je povinným předmětem absolutoria a je rozdělen do tří modulů. Jednotlivé moduly mají následující obsah:

- Modul DAT10 je tematicky zaměřen na historii a vývoj databázových systémů
- Modul DAT20 je tematicky zaměřen na programovací jazyky
- Modul DAT30 je tematicky zaměřen na využití databázových systémů

## DAT10

**Hodnocení modulu:** zkouška (4 kredity)

**Období modulu:** 3. semestr (zimní období)

**Obsah modulu:**
- Úvod do databázových systémů
- Základní pojmy databázových systémů
- Historie modely dat
- Architektury SŘBD (DBMS)
- Systémy řízení bází dat MySQL,
- SQLite, Oracle, MS SQL Server, MS Access…
- Konceptuální modelování
- Diagram výskytů, parcialita, kardinalita
- E-R schéma (různé notace, dekompozice…)
- Relační model dat
- Principy relačního modelu dat
- Převod konceptuálního modelu na relační model dat

## DAT20

**Hodnocení modulu:** zkouška (5 kreditů)

**Období modulu:** 5. semestr (zimní období)

**Obsah modulu:**
- Normální formy
- Základy SQL
- Historie, vývoj, verze, užití a základní principy dotazovacího jazyka SQL
- Datové typy
- Modifikátory integritního omezení
- DDL, CREATE, DROP, ALTER
- DML, INSERT, UPDATE, DELETE, SELECT (projekce, selekce, spojení, řazení, limit)
- Pokročilé SQL o SELECT
- Podmínky (logické výrazy, logické spojky, IS, LIKE, NULL…)
- Spojování více relací (JOIN, LEFT JOIN…)
- Vnořování dotazů SELECT do dotazu SELECT, UPDATE…
- Seskupování a agregační funkce

## DAT30

**Hodnocení modulu:** zkouška (5 kreditů)

**Období modulu:** 6. semestr (letní období)

**Obsah modulu:**
- Pojmenování (AS)
- Funkce pro práci s řetězci, datem a časem, matematické…
- Pohledy, Triggery, DCL, GRANT, REVOKE…
- TCL, COMMIT, ROLLBACK…
- Další speciální příklady využití jazyka SQL
- Best Praktice
- Bezpečnost dat, SQL injection
- Seznámení s vybranými databázovými systémy
- Životní cyklus databázového systému
- Databázový projekt (Návrh, Konceptuální model, Relační model, SQL, Realizace a údržba)

## Okruhy k absolutoriu

1. **Úvod do databázových systémů**: základní pojmy (data, informace, DB, SŘBD, DBS), historie a generace datových modelů (hierarchický, síťový, relační, NoSQL)
2. **Architektury a systémy řízení bází dat**: architektura SŘBD, model klient-server, vícevrstvé architektury, přehled a srovnání moderních SŘBD (MySQL, MariaDB, PostgreSQL, MS SQL Server, Oracle, SQLite)
3. **Konceptuální modelování a E-R diagramy**: entity, atributy, vztahy, diagram výskytů, kardinalita (1:1, 1:N, M:N), parcialita a totálnost vazeb, notace E-R diagramů
4. **Relační model dat**: relace, n-tice, atributy, domény, primární a cizí klíče, vztah relační algebry k relačnímu modelu (selekce, projekce, spojení)
5. **Transformace konceptuálního modelu na relační model**: pravidla převodu entit a vztahů do relací, řešení vztahů 1:1, 1:N a dekompozice vazby M:N pomocí asociační tabulky
6. **Normalizace relačních databází**: anomálie při manipulaci s daty (vkládání, aktualizace, mazání), funkční závislosti, 1. NF, 2. NF, 3. NF a Boyce-Coddova normální forma (BCNF)
7. **Jazyk SQL a datové typy**: rozdělení jazyka SQL (DDL, DML, DQL, DCL, TCL), standardy SQL, kategorizace a volba datových typů (číselné, textové, datum a čas, binární, boolean)
8. **Definice datových struktur (DDL)**: příkazy CREATE, ALTER, DROP, TRUNCATE, správa tabulek, schémat a databází
9. **Integritní omezení a referenční integrita**: primární klíče, cizí klíče, unikátnost (UNIQUE), NOT NULL, kontrolní výrazy (CHECK), referenční akce při smazání/změně (CASCADE, SET NULL, RESTRICT)
10. **Manipulace s daty (DML)**: příkazy INSERT, UPDATE, DELETE, vkládání a aktualizace dat s podmínkou, hromadné operace, zachování integrity při změnách
11. **Dotazovací jazyk (DQL) – základy příkazu SELECT**: struktura dotazu SELECT, projekce, selekce (WHERE), operátory, logické spojky, testování NULL hodnot (IS NULL), řazení (ORDER BY), stránkování (LIMIT/OFFSET)
12. **Spojování tabulek (JOIN)**: princip spojování, kartézský součin (CROSS JOIN), vnitřní spojení (INNER JOIN), vnější spojení (LEFT, RIGHT, FULL OUTER JOIN), self-join, aliasy tabulek
13. **Agregační funkce a seskupování dat**: agregační funkce (COUNT, SUM, AVG, MIN, MAX), klauzule GROUP BY, filtrování skupin pomocí klauzule HAVING, rozdíl mezi WHERE a HAVING
14. **Vnořené dotazy (subqueries)**: poddotazy v klauzulích WHERE, FROM a SELECT, nekorelované a korelované poddotazy, operátory IN, NOT IN, EXISTS, ANY, ALL
15. **Vestavěné skalární funkce a výrazy v SQL**: textové a řetězcové funkce, funkce pro práci s datem a časem, matematické funkce, podmíněné výrazy (CASE) a formátování výsledků
16. **Pohledy (VIEW)**: princip a definice pohledů (CREATE VIEW), význam (abstrakce, bezpečnost, zjednodušení komplexních dotazů), aktualizovatelné pohledy
17. **Transakce a transakční zpracování (TCL)**: princip transakce, vlastnosti ACID (atomicita, konzistence, izolace, odolnost), řízení transakcí (COMMIT, ROLLBACK, SAVEPOINT), úrovně izolace a zamykání
18. **Programovatelné objekty a správa přístupu (DCL)**: databázové triggery (události BEFORE/AFTER), uložené procedury a funkce, správa uživatelů a oprávnění (GRANT, REVOKE, role)
19. **Indexování a bezpečnost databází**: princip a typy indexů (B-strom), vliv na výkon čtení a zápisu, bezpečnostní hrozby, SQL injection a obrana (parametrizované dotazy), zálohování a obnova
20. **Životní cyklus a realizace databázového projektu**: fáze návrhu a implementace DB (analýza požadavků, koncept, relační schéma, tvorba DDL, naplnění testovacími daty, testování, optimalizace, dokumentace)