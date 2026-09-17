# Výukové materiály VOŠ – Pokyny pro vývoj a AI asistenty

Tento repozitář obsahuje komplexní výukové materiály pro Vyšší odbornou školu (VOŠ) a Střední školu pro předměty:
- **DAT** (Databázové systémy – osnova: [docs/dat_databazove_systemy.md](docs/dat_databazove_systemy.md), např. `DAT/DAT20`, ukázkový model `DAT/edu_eshop`)
- **WEB** (Webové technologie – osnova: [docs/web_webove_technologie.md](docs/web_webove_technologie.md), moduly `WEB/WEB10`, `WEB/WEB20`)
- **OSY** (Operační systémy – osnova: [docs/osy_operacni_systemy.md](docs/osy_operacni_systemy.md))
- **MUL** (Multimédia – osnova: [docs/mul_multimedia.md](docs/mul_multimedia.md))

---

## Standard tvorby prezentací a materiálů

Při vytváření dalších výukových prezentací a modulů se řiďte dokumentací v:
- **Kompletní manuál a design systém:** [docs/presentation_framework_guide.md](docs/presentation_framework_guide.md)
- **Pravidla pro asistenta:** [.agents/rules/presentation-guidelines.md](.agents/rules/presentation-guidelines.md)

### Klíčové zásady ve zkratce:
1. **Sdílené jádro & DRY strategie:** Společný vzhled, typografie, komponenty a JavaScriptové enginy se nacházejí v kořenové složce `/assets/` (`presentation-core.css`, `dashboard-core.css`, `presentation-core.js`, `dashboard-core.js`, `syntax/`). Lokální složky modulů obsahují pouze tenké styly s oborovými specifiky a akcenty.
2. **Názvy souborů:** `XX_[nazev_kapitoly].html` s dvouciferným číslem a výstižným názvem (např. `01_normalizace_a_normalni_formy.html`).
3. **Ikony:** VÝHRADNĚ jednobarevné vektorové inline SVG s `currentColor`. Zákaz barevných emotikonů.
4. **Technologie:** 100% offline, Vanilla HTML5 + CSS + JS, relativní cesty, žádné externí závislosti, UTF-8 bez BOM.
5. **Design:** Moderní tmavý motiv s možností přepnutí na světlý, plynulé animace, glassmorphism, tlačítko pro kopírování kódu.
6. **Sjednocená navigace & ovládání:** Pevná 5-úrovňová struktura (Rozcestník → Předmět s horní lištou zpět → Modul s drobečkovou navigací a brand-icon odkazem → Prezentace se standardním controls-barem → Snímky). Přímo v ovládací liště prezentace je sdružený blok pro okamžitý přechod na předchozí / další téma v modulu (`#prevLessonBtn`, `#nextLessonBtn`) i katalog modulu (`#moduleBtn`). Celé dlaždice na všech úrovních jsou klikatelné. Kompletní klávesové zkratky (posun snímků: šipky, mezerník; přechod lekcí: `Ctrl + Šipky` / `Shift + P/N`; `F` fullscreen, `M`/`O` obsah, `T` téma, `G` slovník, `?` nápověda), URL kotvy `#slide-N`, swipe pro dotyková zařízení.
