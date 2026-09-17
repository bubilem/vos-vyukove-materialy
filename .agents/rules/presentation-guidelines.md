---
description: Závazná pravidla a standardy pro tvorbu webových výukových prezentací v projektu vos_vyukove_materialy
globs: ["**/*.html", "**/assets/**"]
---

# Pravidla pro tvorbu výukových prezentací (VOŠ)

Při vytváření nebo úpravách výukových materiálů a prezentací v tomto repozitáři vždy striktně dodržuj následující pravidla (podrobná dokumentace viz `docs/presentation_framework_guide.md`):

1. **Pojmenování spouštěcích HTML souborů:**
   - Vždy použij formát `XX_[nazev_kapitoly].html`, kde `XX` je dvouciferné číslo kapitoly (`01_`, `02_`, ..., `10_`) a následuje výstižný název tématu bez diakritiky s podtržítky.
   - Příklad: `01_normalizace_a_normalni_formy.html`, `07_spojovani_tabulek_join.html`.
   - V kořenu každého modulu musí být katalog `index.html` s funkčními odkazy na všechny prezentace.

2. **ZÁKAZ BAREVNÝCH EMOJI (V HTML I MARKDOWNU):**
   - Je přísně zakázáno používat jakékoli barevné emotikony – v HTML prezentacích, CSS, JS i ve všech Markdown (`.md`) souborech, dokumentaci a komentářích.
   - V HTML musí být všechny ikony výhradně **jednobarevné vektorové inline SVG** (`viewBox="0 0 24 24"`, `fill="none"`, `stroke="currentColor"`, `stroke-width="2"`), které přebírají barvu textu (`currentColor`).
   - V Markdown souborech nepoužívej žádné emotikony (žádné symboly jako špendlíky, čepice, žárovky atd.). Text formátuj čistou typografií a standardním Markdownem.

3. **Architektura assetů a DRY strategie (Don't Repeat Yourself):**
   - **Centrální jádro v kořeni repozitáře:** Všechny sdílené definice vzhledu, typografie, layoutu slidů, ovládací lišty a JS enginů jsou uloženy v `/assets/`:
     - `assets/css/presentation-core.css` – sdílené jádro prezentací.
     - `assets/css/dashboard-core.css` – sdílené jádro katalogů a rozcestníků (obsahuje `.breadcrumb-nav`, hover efekty pro karty a `a.brand-icon`).
     - `assets/css/syntax/` – modulární styly pro zvýrazňování kódu (`sql.css`, `web.css`, `terminal.css`).
     - `assets/js/presentation-core.js` – společný JavaScriptový engine prezentací.
     - `assets/js/dashboard-core.js` – společný JavaScript pro rozcestníky modulů (správa motivu, vyhledávání, klikatelnost celých karet).
   - **Lokální modulové assety:** Složky `[OBOR]/[MODUL]/assets/` obsahují pouze tenké přetížené styly se specifiky daného předmětu (specifická akcentní barva, modely databází, specifická schémata).
   - Všechny cesty musí být relativní (`../../assets/...`), aby materiály fungovaly 100% offline bez serveru z protokolu `file://`.
   - Kódování všech souborů je striktně **UTF-8 bez BOM**.

4. **Design systém a interaktivita:**
   - Výchozí je moderní tmavý motiv (Dark mode) s možností přepnutí do světlého motivu (`[data-theme="light"]`).
   - Zachovávej ambientní záři (`.bg-glow-1`, `.bg-glow-2`), technologickou mřížku na pozadí a gradientní nadpisy (`background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent;`).
   - Každá prezentace má plnou podporu klávesnice: `Šipky` (snímky), `Mezerník` (vpřed), `F` (fullscreen), `M`/`O` (obsah/osnova), `T` (přepnutí motivu), `G` (slovník pojmů, jen pokud přítomen), `?` (nápověda), `Esc` (zavření modálů).
   - Ukázky kódu musí mít hlavičku a tlačítko `.btn-copy` s funkčním kopírováním do schránky.

5. **Obsah snímků – rámečky (Cards):**
   - Pro obalení obsahových bloků na snímku VŽDY použij třídu `.content-card` (nebo `.card` — jsou identické aliasy definované v `presentation-core.css`).
   - Třída `.content-card` automaticky zajistí: `border`, `border-radius`, `backdrop-filter`, `box-shadow` a hover efekt — bez nutnosti inline stylů.
   - Pro stylizované odrážkové seznamy použij `<ul class="styled-list">` — definováno v core.
   - Pro SVG ikony v nadpisech karet použij `<svg class="icon card-icon">` — zajistí správnou velikost a barvu.

6. **Navigační hierarchie webu (5 úrovní) a sjednocená klikatelnost dlaždic — POVINNÉ:**
   Projekt má pevnou 5-úrovňovou hierarchii, kde **celé dlaždice na všech úrovních jsou klikatelné**:

   ```
   Úroveň 0: Hlavní rozcestník  →  index.html (kořen projektu)
             ↓ Celá dlaždice předmětu (<a class="subject-card">) je odkaz
   Úroveň 1: Stránka předmětu   →  DAT/index.html | WEB/index.html | OSY/index.html | MUL/index.html
             • Horní lišta .nav-bar s tlačítkem "← Zpět na centrální rozcestník" (.nav-back) + přepínač motivu (.theme-toggle-btn)
             ↓ Celá dlaždice modulu (<a class="module-card">) je odkaz
   Úroveň 2: Stránka modulu     →  DAT/DAT20/index.html | WEB/WEB10/index.html | ...
             • Drobečková navigace (.breadcrumb-nav): Hlavní rozcestník / Předmět [X] / Modul [X##]
             • Ikonka předmětu v hlavičce je odkaz: <a href="../index.html" class="brand-icon" title="Zpět na přehled předmětu...">
             • Společný skript: assets/js/dashboard-core.js
             ↓ Celá dlaždice lekce (.lesson-card) je klikatelná (click delegation v dashboard-core.js)
   Úroveň 3: Prezentace         →  DAT/DAT20/01_xxx.html | WEB/WEB10/01_xxx.html | ...
             • Spodní lišta: #homeBtn (../../index.html), #moduleBtn (index.html), posun, TOC, Slovník, Fullscreen, Help
             • Společný skript: assets/js/presentation-core.js
             ↓ šipky / mezerník / TOC
   Úroveň 4: Snímek             →  #slide-N (řízeno JS enginem, URL hash, swipe, klávesnice)
   ```

   **Navigace zpět (v každé prezentaci):**
   - Tlačítko `#homeBtn` → `../../index.html` (Domů — hlavní rozcestník, vždy 2 úrovně výše)
   - Tlačítko `#moduleBtn` → `index.html` (← Zpět na modul)
   - Badge v headeru `← NAZEV_MODULU` → `index.html` (alternativní odkaz)

7. **Standardní Controls Bar — povinná struktura (NEKOPÍRUJ jiné varianty):**
   Každá prezentace musí mít přesně tento `<nav class="controls-bar">` (nebo s `aria-label`):

   ```html
   <nav class="controls-bar" aria-label="Ovládání prezentace">
     <!-- NAVIGACE HIERARCHIÍ -->
     <a href="../../index.html" class="control-btn" id="homeBtn" title="Domů – hlavní rozcestník">
       <svg class="icon" viewBox="0 0 24 24"><!-- dům SVG --></svg>
     </a>
     <a href="index.html" class="control-btn" id="moduleBtn" title="← Zpět na modul">
       <svg class="icon" viewBox="0 0 24 24"><!-- šipka zpět SVG --></svg>
     </a>
     <div class="controls-divider"></div>
     <!-- POSUN PO SNÍMCÍCH -->
     <button class="control-btn" id="prevSlideBtn" title="Předchozí snímek (Šipka vlevo)">...</button>
     <span class="slide-counter" id="slideCounter" title="Otevřít osnovu snímků">01 / 01</span>
     <button class="control-btn btn-nav-primary" id="nextSlideBtn" title="Další snímek (Mezerník / Šipka vpravo)">...</button>
     <div class="controls-divider"></div>
     <!-- NÁSTROJE -->
     <button class="control-btn" id="tocToggleBtn" title="Obsah lekce (M)">...</button>
     <!-- SLOVNÍK: vždy přítomen s display:none, JS engine ho zobrazí pokud existuje #glossaryModal -->
     <button class="control-btn" id="glossaryBtn" title="Slovník pojmů (G)" style="display:none">...</button>
     <button class="control-btn" id="fullscreenBtn" title="Celá obrazovka (F)">...</button>
     <button class="control-btn" id="helpToggleBtn" title="Klávesové zkratky (?)">...</button>
   </nav>
   ```

   **Klíčové ID kontrolérů (rozpoznávány JS enginem):**
   - `homeBtn`, `moduleBtn` — navigace hierarchií (nové, JS engine je nepotřebuje ale musí být správně)
   - `prevSlideBtn`, `nextSlideBtn` — posun snímků
   - `slideCounter` — počítadlo (klik = TOC)
   - `tocToggleBtn`, `tocOverlay`, `tocCloseBtn`, `tocList` — osnova
   - `glossaryBtn`, `glossaryModal` — slovník (zobrazí se auto pokud #glossaryModal existuje)
   - `fullscreenBtn` — fullscreen
   - `helpToggleBtn`, `helpModal`, `helpCloseBtn` — nápověda klávesnice
   - `themeToggleBtn` — v headeru, přepnutí motivu
   - `progressBarFill` — v headeru, lišta průběhu

8. **Slovník pojmů (Glossary):**
   - Je-li prezentace rozsáhlá a odborná (obvykle MUL20/OSY20 typ), přidej slovník jako `<div class="modal-overlay" id="glossaryModal">`.
   - JS engine (`presentation-core.js`) automaticky detekuje přítomnost `#glossaryModal` a zobrazí tlačítko `#glossaryBtn` v controls baru.
   - Klávesová zkratka: `G`

9. **Didaktická jednotka a vazba na zkoušky:**
   - Prezentace je dimenzována na 45 minut (5–8 propracovaných, informačně bohatých slidů).
   - Obsahuje Titulní slide s metadaty, teoretický základ, praktické ukázky na reálném modelu předmětu a závěrečný slide se shrnutím a zkušebním checklistem (např. okruhy absolutoria).
