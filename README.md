# Výukové materiály VOŠ a SŠ – Informační technologie

Komplexní otevřená platforma interaktivních výukových materiálů a webových prezentací pro Vyšší odbornou školu (VOŠ) a Střední školu (SŠ). Projekt pokrývá klíčové kurikulární pilíře odborného IT vzdělávání: **Databázové systémy (DAT)**, **Webové technologie (WEB)**, **Operační systémy (OSY)** a **Multimédia (MUL)**.

Všechny materiály jsou dimenzovány na 45minutové didaktické jednotky, jsou navrženy pro **100% offline provoz** bez nutnosti serveru a přímo navazují na schválené profilové maturitní a absolutorní zkušební okruhy.

**Online výukový portál:** [https://bubilem.github.io/vos-vyukove-materialy/](https://bubilem.github.io/vos-vyukove-materialy/)

---

## Přehled předmětů a modulů

| Předmět | Název a zaměření | Moduly v repozitáři | Počet lekcí | Výchozí akcent |
| :--- | :--- | :--- | :---: | :--- |
| **DAT** | **Databázové systémy**<br>Konceptuální E-R modelování, normální formy, SQL (DDL, DML, DQL), transakce (ACID) a správa SŘBD. Dotazy nad modelem `edu_eshop`. | DAT10 (Úvod & modelování)<br>**DAT20 (SQL & Relační DB)**<br>DAT30 (Správa SŘBD) | **10** | Azurová (`#06b6d4`) |
| **WEB** | **Webové technologie**<br>Sémantický HTML5, pokročilý responzivní CSS layout (Flexbox, Grid), architektury (BEM), preprocesory (Sass) a moderní JavaScript. | **WEB10 (Základy webu)**<br>**WEB20 (Moderní CSS)**<br>WEB30 (JS & Aplikace) | **20** | Modrá (`#38bdf8`) |
| **OSY** | **Operační systémy**<br>Architektura kernelu, privilegované režimy, procesy a CFS plánovač, správa paměti a stránkování, souborové systémy ext4/NTFS a bezpečnost. | **OSY10 (Základy OS)**<br>**OSY20 (Kernel & Správa)** | **20** | Zelená (`#10b981`) |
| **MUL** | **Multimédia**<br>Vzorkování a digitalizace zvuku (Nyquist), rastrová a vektorová grafika, komprese videa (H.264, HEVC, AV1), technika zvuku, fotografie a rozhraní. | **MUL10 (Digitální formáty)**<br>**MUL20 (Tvorba a technika)**<br>MUL30 (3D & Postprodukce) | **20** | Fialová (`#a855f7`) / Růžová (`#ec4899`) |

---

## Architektura repozitáře (DRY Model)

Framework využívá dvouvrstvou architekturu oddělující společné jádro od oborových specifik:

```text
d:\Skola\vos_vyukove_materialy/
├── index.html                                    # Hlavní centrální rozcestník všech předmětů
├── .gitignore                                    # Pravidla vyloučení pro Git
├── README.md                                     # Hlavní dokumentace projektu
├── AGENTS.md                                     # Pravidla a standardy pro AI asistenty
│
├── assets/                                       # Globální sdílené jádro pro všechny předměty
│   ├── css/
│   │   ├── presentation-core.css                 # Sdílené jádro prezentací (layout, typografie, modály)
│   │   ├── dashboard-core.css                    # Sdílené jádro katalogů a rozcestníků
│   │   └── syntax/                               # Zvýrazňování kódu (sql.css, web.css, terminal.css)
│   └── js/
│       └── presentation-core.js                  # Globální engine (klávesnice, swipe, fullscreen, TOC, vzorce)
│
├── DAT/                                          # Předmět Databázové systémy
│   ├── index.html                                # Předmětový katalog DAT
│   ├── edu_eshop/                                # Referenční schéma a datový model pro výuku
│   └── DAT20/                                   # Modul DAT20: Relační databáze a SQL (10 lekcí)
│
├── WEB/                                          # Předmět Webové technologie
│   ├── index.html                                # Předmětový katalog WEB
│   ├── WEB10/                                   # Modul WEB10: Základy webu a sémantika (10 lekcí)
│   └── WEB20/                                   # Modul WEB20: Moderní CSS a layouty (10 lekcí)
│
├── OSY/                                          # Předmět Operační systémy
│   ├── index.html                                # Předmětový katalog OSY
│   ├── OSY10/                                   # Modul OSY10: Architektura a základy OS (10 lekcí)
│   └── OSY20/                                   # Modul OSY20: Pokročilá správa prostředků (10 lekcí)
│
├── MUL/                                          # Předmět Multimédia
│   ├── index.html                                # Předmětový katalog MUL
│   ├── MUL10/                                    # Modul MUL10: Základy a digitální formáty (10 lekcí)
│   └── MUL20/                                    # Modul MUL20: Technika a tvorba multimédií (10 lekcí)
│
└── docs/                                         # Metodika, sylaby a zkušební osnovy
    ├── presentation_framework_guide.md           # Technický a designový standard frameworku
    ├── dat_databazove_systemy.md                 # Sylabus DAT
    ├── web_webove_technologie.md                 # Sylabus WEB
    ├── osy_operacni_systemy.md                   # Sylabus OSY
    └── mul_multimedia.md                         # Sylabus MUL
```

---

## Klíčové technologické vlastnosti

1. **100% Offline podpora bez nutnosti webového serveru:**
   Všechny soubory jsou vzájemně propojeny pomocí relativních cest. Prezentace i katalogy fungují bezchybně při přímém otevření ze souborového systému (protokol `file:///`) i na zařízeních bez přístupu k internetu.
2. **Klávesové ovládání a dotyková gesta:**
   Plná podpora ovládání prezentací pomocí klávesových zkratek i gest potažení (swipe) na tabletech a mobilních zařízeních.
3. **Nativní matematický engine (LaTeX Math):**
   Součástí jádra `presentation-core.js` je offline parser matematických a fyzikálních vzorců. Zápisy typu `$C = \varepsilon S / d$`, `$f_s > 2 \times f_{max}$`, `$$\text{SNR} \approx 6.02 \times n + 1.76\text{ dB}$$` i úhlové stupně se automaticky typograficky sází bez závislosti na externích CDN či webových fontech.
4. **Tmavý a světlý motiv (Dark / Light Mode):**
   Výchozím režimem je moderní technologický tmavý motiv s ambientními barevnými přechody. Režim lze kdykoli přepnout klávesou `T` nebo tlačítkem v liště; preference se ukládá do `localStorage` (`vos_presentation_theme`).
5. **Kopírování ukázek kódu:**
   Každý blok ukázky kódu obsahuje tlačítko pro okamžité zkopírování do schránky se zpětnou vazbou.
6. **Dynamická interaktivní osnova (TOC Drawer):**
   Stisknutím klávesy `M` nebo `O` se vysune postranní panel se seznamem všech snímků prezentace a možností přímého skoku.

---

## Přehled klávesových zkratek

Během prohlížení libovolné prezentace jsou k dispozici následující klávesy:

| Klávesa | Akce |
| :--- | :--- |
| `Šipka vpravo` / `Mezerník` / `PageDown` | Přechod na následující snímek |
| `Šipka vlevo` / `Backspace` / `PageUp` | Přechod na předchozí snímek |
| `Home` / `End` | První / Poslední snímek prezentace |
| `F` | Přepnutí režimu celé obrazovky (Fullscreen) |
| `M` nebo `O` | Otevření / zavření osnovy prezentace (TOC drawer) |
| `T` | Přepnutí mezi tmavým a světlým motivem |
| `?` | Zobrazení modálního okna s nápovědou ovládání |
| `Esc` | Zavření otevřeného modálního okna nebo osnovy |

---

## Nasazení na GitHub Pages

Projekt je publikován a živě provozován na GitHub Pages:

- **Živá produkční URL:** [https://bubilem.github.io/vos-vyukove-materialy/](https://bubilem.github.io/vos-vyukove-materialy/)
- **Repozitář projektu:** [https://github.com/bubilem/vos-vyukove-materialy](https://github.com/bubilem/vos-vyukove-materialy)

### Nastavení GitHub Pages:
V nastavení repozitáře na GitHubu (**Settings &rarr; Pages**):
- **Source:** `Deploy from a branch`
- **Branch:** `main` &bull; `/ (root)`

> **Poznámka:** Všechny cesty jsou striktně relativní, web proto bezchybně funguje v podsložkovém repozitáři GitHub Pages i při přímém offline otevření z disku.

---

## Lokální spuštění

Materiály lze spustit několika způsoby:

1. **Přímo z disku (doporučeno pro offline výuku):**
   Stačí poklepat na [`index.html`](index.html) v kořeni projektu v libovolném moderním webovém prohlížeči (Chrome, Firefox, Safari, Edge).
2. **Pomocí lokálního HTTP serveru:**
   Pokud preferujete běh přes HTTP server, spusťte v kořeni repozitáře libovolný z následujících příkazů:
   - **Python 3:** `python -m http.server 8000`
   - **Node.js (npx):** `npx serve .`
   - **PHP:** `php -S localhost:8000`
   Následně otevřete v prohlížeči adresu `http://localhost:8000`.

---

## Závazná didaktická a designová pravidla

Při rozšiřování obsahu a tvorbě dalších modulů je nutné dodržovat standardy specifikované v [`docs/presentation_framework_guide.md`](docs/presentation_framework_guide.md) a [`AGENTS.md`](AGENTS.md):

1. **Zákaz barevných emotikonů (No Emoji Policy):**
   V HTML, CSS, JS i Markdown dokumentaci je přísně zakázáno používat barevné grafické emotikony. Veškeré ikony musí být výhradně jednobarevné inline vektorové SVG s `stroke="currentColor"`.
2. **Pojmenování souborů lekcí:**
   Vždy dvouciferné číslo a název bez diakritiky s podtržítky: `XX_[nazev_lekce].html` (např. `01_normalizace_a_normalni_formy.html`).
3. **Struktura lekce:**
   Každá prezentace obsahuje 5–8 propracovaných slidů odpovídajících 45minutové vyučovací jednotce: Titulní slide s metadaty &rarr; Teoretický úvod &rarr; Výklad a syntax &rarr; Praktická aplikace &rarr; Závěrečné shrnutí a zkušební checklist k absolutoriu.
