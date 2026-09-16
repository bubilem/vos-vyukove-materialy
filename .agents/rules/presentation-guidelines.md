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
   - **Centrální jádro v kořeni repozitáře:** Všechny sdílené definice vzhledu, typografie, layoutu slidů, ovládací lišty a JS enginu jsou uloženy v `/assets/`:
     - `assets/css/presentation-core.css` – sdílené jádro prezentací.
     - `assets/css/dashboard-core.css` – sdílené jádro katalogů a rozcestníků.
     - `assets/css/syntax/` – modulární styly pro zvýrazňování kódu (`sql.css`, `web.css`, `terminal.css`).
     - `assets/js/presentation-core.js` – společný JavaScriptový engine prezentací.
   - **Lokální modulové assety:** Složky `[OBOR]/[MODUL]/assets/` obsahují pouze tenké přetížené styly se specifiky daného předmětu (specifická akcentní barva, modely databází, specifická schémata).
   - Všechny cesty musí být relativní (`../../assets/...`), aby materiály fungovaly 100% offline bez serveru z protokolu `file://`.

4. **Design systém a interaktivita:**
   - Výchozí je moderní tmavý motiv (Dark mode) s možností přepnutí do světlého motivu (`[data-theme="light"]`).
   - Zachovávej ambientní záři (`.bg-glow-1`, `.bg-glow-2`), technologickou mřížku na pozadí a gradientní nadpisy (`background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent;`).
   - Každá prezentace má plnou podporu klávesnice (`Šipky`, `Mezerník`, `F` fullscreen, `M`/`O` obsah/osnova, `T` přepnutí motivu, `?` nápověda, `Esc`).
   - Ukázky kódu musí mít hlavičku a tlačítko `.btn-copy` s funkčním kopírováním do schránky.

5. **Didaktická jednotka a vazba na zkoušky:**
   - Prezentace je dimenzována na 45 minut (5–8 propracovaných, informačně bohatých slidů).
   - Obsahuje Titulní slide s metadaty, teoretický základ, praktické ukázky na reálném modelu předmětu a závěrečný slide se shrnutím a zkušebním checklistem (např. okruhy absolutoria).
