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

   **Navigace a přechod mezi tématy (v každé prezentaci):**
   - Tlačítko `#prevLessonBtn` → `XX_predchozi_lekce.html` (nebo stav `disabled` u první lekce)
   - Tlačítko `#moduleBtn` → `index.html` (přehled modulu, ikona grid/katalogu)
   - Tlačítko `#nextLessonBtn` → `XX_dalsi_lekce.html` (nebo stav `disabled` u poslední lekce)
   - Badge v headeru `← NAZEV_MODULU` → `index.html` (návrat do modulu)

7. **Standardní Controls Bar — povinná struktura (NEKOPÍRUJ jiné varianty):**
   Každá prezentace musí mít přesně tento `<nav class="controls-bar">` se sdruženým blokem přechodu mezi tématy:

   ```html
   <nav class="controls-bar" aria-label="Ovládání prezentace">
     <!-- PŘECHOD MEZI LEKCEMI A MODUL (Varianta A) -->
     <a href="01_predchozi.html" class="control-btn" id="prevLessonBtn" title="Předchozí lekce: Název (Ctrl+Šipka vlevo)">
       <svg class="icon" viewBox="0 0 24 24"><polyline points="11 17 6 12 11 7"></polyline><polyline points="18 17 13 12 18 7"></polyline></svg>
     </a>
     <a href="index.html" class="control-btn" id="moduleBtn" title="Přehled modulu MODUL">
       <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
     </a>
     <a href="03_dalsi.html" class="control-btn" id="nextLessonBtn" title="Další lekce: Název (Ctrl+Šipka vpravo)">
       <svg class="icon" viewBox="0 0 24 24"><polyline points="13 17 18 12 13 7"></polyline><polyline points="6 17 11 12 6 7"></polyline></svg>
     </a>
     <div class="controls-divider"></div>
     <!-- POSUN PO SNÍMCÍCH -->
     <button class="control-btn" id="prevSlideBtn" title="Předchozí snímek (Šipka vlevo)">
       <svg class="icon" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"></polyline></svg>
     </button>
     <span class="slide-counter" id="slideCounter" title="Otevřít osnovu snímků">01 / 01</span>
     <button class="control-btn btn-nav-primary" id="nextSlideBtn" title="Další snímek (Mezerník / Šipka vpravo)">
       <svg class="icon" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
     </button>
     <div class="controls-divider"></div>
     <!-- NÁSTROJE -->
     <button class="control-btn" id="tocToggleBtn" title="Obsah lekce (M)">
       <svg class="icon" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>
     </button>
     <!-- SLOVNÍK: vždy přítomen s display:none, JS engine ho zobrazí pokud existuje #glossaryModal -->
     <button class="control-btn" id="glossaryBtn" title="Slovník pojmů (G)" style="display:none">
       <svg class="icon" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
     </button>
     <button class="control-btn" id="fullscreenBtn" title="Celá obrazovka (F)">
       <svg class="icon" viewBox="0 0 24 24"><path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"></path></svg>
     </button>
     <button class="control-btn" id="helpToggleBtn" title="Klávesové zkratky (?)">
       <svg class="icon" viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2" ry="2"></rect><line x1="6" y1="8" x2="6.01" y2="8"></line><line x1="10" y1="8" x2="10.01" y2="8"></line><line x1="14" y1="8" x2="14.01" y2="8"></line><line x1="18" y1="8" x2="18.01" y2="8"></line><line x1="6" y1="12" x2="6.01" y2="12"></line><line x1="10" y1="12" x2="10.01" y2="12"></line><line x1="14" y1="12" x2="14.01" y2="12"></line><line x1="18" y1="12" x2="18.01" y2="12"></line><line x1="8" y1="16" x2="16" y2="16"></line></svg>
     </button>
   </nav>
   ```

   **Pravidla pro první a poslední lekci modulu:**
   - U 1. lekce (`01_...`): `#prevLessonBtn` má třídu `control-btn disabled`, `aria-disabled="true"`, `tabindex="-1"`, `href="#"` a title `Předchozí lekce (žádná předchozí není)`.
   - U poslední lekce (`10_...`): `#nextLessonBtn` má třídu `control-btn disabled`, `aria-disabled="true"`, `tabindex="-1"`, `href="#"` a title `Další lekce (žádná další není)`.
   - Rozměr tlačítka (38×38 px) a ikona zůstávají, aby lišta neposkakovala.

   **Klíčové ID kontrolérů a klávesové zkratky:**
   - `prevLessonBtn`, `nextLessonBtn` — přechod mezi lekcemi (`Ctrl + Šipka vlevo / vpravo`, případně `Shift + P / N`)
   - `moduleBtn` — návrat do katalogu modulu (ikona mřížky/gridu)
   - `prevSlideBtn`, `nextSlideBtn` — posun po snímcích (`Šipka vlevo / vpravo`, `Backspace`, `Mezerník`)
   - `slideCounter` — počítadlo snímků (klik = otevření osnovy)
   - `tocToggleBtn`, `tocOverlay`, `tocCloseBtn`, `tocList` — osnova lekce (`M`, `O`)
   - `glossaryBtn`, `glossaryModal` — slovník pojmů (`G`, auto-detekce)
   - `fullscreenBtn` — celá obrazovka (`F`)
   - `helpToggleBtn`, `helpModal`, `helpCloseBtn` — dialog nápovědy (`?`, `Escape`)
   - `themeToggleBtn` — v horní liště, přepnutí motivu (`T`)

8. **Slovník pojmů (Glossary):**
   - Je-li prezentace rozsáhlá a odborná (obvykle MUL20/OSY20 typ), přidej slovník jako `<div class="modal-overlay" id="glossaryModal">`.
   - JS engine (`presentation-core.js`) automaticky detekuje přítomnost `#glossaryModal` a zobrazí tlačítko `#glossaryBtn` v controls baru.
   - Klávesová zkratka: `G`

9. **Didaktická jednotka a vazba na zkoušky:**
   - Prezentace je dimenzována na 45 minut (5–8 propracovaných, informačně bohatých slidů).
   - Obsahuje Titulní slide s metadaty, teoretický základ, praktické ukázky na reálném modelu předmětu a závěrečný slide se shrnutím a zkušebním checklistem (např. okruhy absolutoria).
