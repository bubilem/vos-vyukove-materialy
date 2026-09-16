# Standard a metodika tvorby výukových prezentací VOŠ

Tento dokument slouží jako závazný technický a didaktický standard pro vytváření interaktivních webových prezentací v projektu **Výukové materiály VOŠ** (`d:\Skola\vos_vyukove_materialy`). Standard je určen pro předměty DAT (Databázové systémy), WEB (Webové technologie), OSY (Operační systémy), MUL (Multimédia) a další.

---

## 1. Architektura a organizace složek (DRY Model)

Framework využívá **dvouvrstvou architekturu (Core Framework + Module Overrides)**, která eliminuje duplicitu kódu (DRY), zaručuje jednotnou typografii i ovládání a umožňuje centrální správu a opravy chyb.

### Stromová struktura repozitáře:
```text
d:\Skola\vos_vyukove_materialy/
├── assets/                                           # Globální sdílené jádro pro všechny předměty
│   ├── css/
│   │   ├── presentation-core.css                     # Jádro prezentací (reset, layout slidů, navigace, modály)
│   │   ├── dashboard-core.css                        # Jádro katalogů a rozcestníků modulů
│   │   └── syntax/                                   # Modulární zvýrazňování syntaxe kódu
│   │       ├── sql.css                               # Tokeny pro DAT (SQL, relační PK/FK odznaky)
│   │       ├── web.css                               # Tokeny pro WEB (HTML, CSS, JS, SCSS)
│   │       └── terminal.css                          # Tokeny pro OSY (Bash, PowerShell)
│   └── js/
│       └── presentation-core.js                      # Globální engine (klávesy, swipe, fullscreen, TOC, téma)
│
├── [ZKRATKA_OBORU]/[KOD_MODULU]/                     # Např. DAT/DAT20, WEB/WEB10, WEB/WEB20
│   ├── index.html                                    # Hlavní katalog / rozcestník modulu
│   ├── 01_[nazev_prvni_kapitoly].html                # Spouštěcí soubor 1. lekce
│   ├── 02_[nazev_druhe_kapitoly].html                # Spouštěcí soubor 2. lekce
│   ├── ...
│   ├── NN_[nazev_n_te_kapitoly].html                 # Spouštěcí soubor N-té lekce
│   └── assets/                                       # Lokální specifika daného modulu
│       ├── css/
│       │   ├── presentation.css                      # Přebírá jádro + definuje specifické proměnné/komponenty
│       │   └── dashboard.css                         # Lokální rozšíření katalogu modulu
│       └── js/
│           └── presentation.js                       # Tenký most / specifické interaktivní widgety modulu
```

### Způsob linkování v prezentačních souborech HTML:
Vzhledem k požadavku na 100% offline provoz v protokolu `file://` linkujeme styly přímo v hlavičce souboru:
```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lekce XX: Název lekce | MODUL</title>
  
  <!-- 1. Globální jádro prezentací -->
  <link rel="stylesheet" href="../../assets/css/presentation-core.css">
  
  <!-- 2. Oborový syntax highlighting -->
  <link rel="stylesheet" href="../../assets/css/syntax/web.css">
  
  <!-- 3. Lokální přetížení a specifika modulu -->
  <link rel="stylesheet" href="assets/css/presentation.css">
</head>
<body>
  ...
  <!-- Na konci stránky: Společný engine prezentací -->
  <script src="../../assets/js/presentation-core.js"></script>
</body>
```

### Pravidla pro pojmenování souborů:
1. **Předpona:** Vždy **dvouciferné pořadové číslo** lekce (`01_`, `02_`, ..., `10_`).
2. **Tělo názvu:** Výstižný název tématu odpovídající obsahu kapitoly (bez diakritiky, malá písmena, slova oddělena podtržítkem `_`).
   - *Správně:* `01_normalizace_a_normalni_formy.html`, `07_spojovani_tabulek_join.html`
   - *Nesprávně:* `lekce01.html`, `01-normalizace.html`, `prezentace1.html`
3. **Přenositelnost:** Všechny cesty musí být **relativní** (`../../assets/...`, `assets/...`, `index.html`), aby balíček fungoval lokálně (offline z disku nebo flashdisku bez webového serveru).

---

## 2. Přísné pravidlo pro ikony: VÝHRADNĚ VEKTOROVÉ SVG

> **DŮLEŽITÉ: ZÁKAZ BAREVNÝCH EMOJI**
> V prezentacích i dashboardu je přísně zakázáno používat standardní barevné emoji symboly (jako 🎓, 💡, ⚠️, 🚨, 🛒, 🔍, 📋, 🏠, ☀️, 🌙 apod.). Barevné emotikony narušují profesionální technologický ráz.

### Standard vektorových ikon:
- Všechny ikony musí být čisté **inline SVG** (standard Feather / Lucide styl).
- Barva se dědí z textu pomocí `currentColor`.
- Standardní parametry elementu `<svg>`:
  ```html
  <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <!-- vektorové cesty -->
  </svg>
  ```
- **Knihovna nejčastějších SVG ikon:**
  - **Info / Tip:** `<circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line>`
  - **Varování / Pozor:** `<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line>`
  - **Zkouška / Absolutorium (Čepice):** `<path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path>`
  - **Databáze / Obor:** `<ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>`
  - **Kód / Závorky:** `<polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline>`
  - **Kopírovat do schránky:** `<rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>`
  - **Kopírováno (fajfka):** `<polyline points="20 6 9 17 4 12"></polyline>`
  - **Obsah / Osnova:** `<line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line>`
  - **Domů (Dashboard):** `<path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline>`
  - **Fullscreen:** `<path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"></path>`
  - **Téma (Slunce):** `<circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>`
  - **Téma (Měsíc):** `<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>`

---

## 3. Vizuální design systém (CSS pravidla)

1. **Výchozí Dark Mode s podporou Light Mode:**
   - Výchozí stav je hluboké tmavé prostředí (`--bg-primary: #0a0f1d;`, `--bg-secondary: #111827;`).
   - Přepnutí probíhá atributem na tagu html: `<html data-theme="light">` přes CSS proměnné.
   - Plynulé přechody (`transition: background 0.3s ease, color 0.3s ease`).
2. **Glassmorphism & vrstvy:**
   - Ambientní zářící ovály (`.bg-glow-1`, `.bg-glow-2`) s `filter: blur(60-70px);`.
   - Jemná technologická mřížka na pozadí (`.bg-grid-overlay`).
   - Poloprůhledné skleněné karty (`background: rgba(17, 24, 39, 0.85); backdrop-filter: blur(12px); border: 1px solid var(--border-color);`).
3. **Typografie a nadpisy:**
   - Systémový moderní font: `font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;`.
   - Gradientní nadpisy:
     ```css
     background: linear-gradient(135deg, var(--text-primary) 30%, var(--text-secondary) 100%);
     background-clip: text;
     -webkit-background-clip: text;
     -webkit-text-fill-color: transparent;
     ```
4. **Barevné akcenty:**
   - Cyan: `--accent-cyan: #06b6d4;` (výchozí pro DAT, relace, primární data)
   - Sky Blue: `--accent: #38bdf8;` (výchozí pro WEB, webové protokoly a sítě)
   - Indigo/Fialová: `--accent-indigo: #6366f1;` (architektonické prvky)
   - Emerald/Zelená: `--accent-emerald: #10b981;` (správné postupy, úspěšné kódy)
   - Amber/Žlutá: `--accent-amber: #f59e0b;` (upozornění na zkoušku / absolutorium)
   - Rose/Červená: `--accent-rose: #f43f5e;` (chyby, nebezpečné operace, varování)

---

## 4. Didaktická struktura prezentace (45minutová jednotka)

Každá prezentace reprezentuje jednu **vyučovací hodinu (45 minut)** a obsahuje optimálně **5 až 8 hutných, didakticky promyšlených slidů**:

| Snímek | Typ / Šablona | Didaktický účel |
|---|---|---|
| **Snímek 1** | **Title / Hero slide** (`.slide--title`) | Uvedení tématu, odznak předmětu, časová dotace 45 min, vazba na okruh absolutoria, cíl lekce. |
| **Snímek 2** | **Teoretický fundament & Motivace** | Proč problém řešíme, jaká jsou rizika špatného návrhu, klíčové pojmy. |
| **Snímek 3–4** | **Jádro výkladu + Syntax + Vizualizace** | Konkrétní syntaxe, tabulková srovnání, diagramy, logické postupy. |
| **Snímek 5–6** | **Praktická aplikace na reálném modelu** | Reálné ukázky kódu s oborovým kontextem, řešení typických úloh. |
| **Poslední slide** | **Syntéza, Shrnutí & Zkušební checklist** (`.summary-grid`) | 3–4 klíčová shrnutí, zkušební otázka a osnova odpovědi k absolutoriu. |

---

## 5. Komponenty pro obsah slidů

### 1. Zvýrazněné bloky (Callouts):
```html
<div class="callout callout-tip">
  <div class="callout-icon">
    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
  </div>
  <div class="callout-content">
    <div class="callout-title">Doporučená praxe</div>
    <p>Text metodického doporučení...</p>
  </div>
</div>
```
Dostupné varianty: `.callout-tip`, `.callout-warning`, `.callout-exam`, `.alert-box`, `.alert-box--info`, `.alert-box--warning`.

### 2. Blok kódu s funkčním kopírováním:
```html
<div class="code-box">
  <div class="code-box-header">
    <span>sql &bull; dotaz</span>
    <button class="btn-copy" title="Kopírovat kód">
      <svg class="icon" viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
      <span>Kopírovat</span>
    </button>
  </div>
  <pre><code><span class="sql-keyword">SELECT</span> * <span class="sql-keyword">FROM</span> tabulka;</code></pre>
</div>
```

### 3. Plovoucí ovládací lišta (`.controls-bar`):
```html
<nav class="controls-bar" aria-label="Ovládání prezentace">
  <div class="controls-left">
    <a href="index.html" class="control-btn" title="Katalog lekcí"><svg ...></svg></a>
    <button class="control-btn" id="tocBtn" title="Obsah (M/O)"><svg ...></svg></button>
  </div>
  <div class="controls-center">
    <button class="control-btn" id="prevBtn"><svg ...></svg></button>
    <span class="slide-counter" id="slideCounter">1 / 6</span>
    <button class="control-btn" id="nextBtn"><svg ...></svg></button>
  </div>
  <div class="controls-right">
    <button class="control-btn" id="themeToggle"><svg ...></svg></button>
    <button class="control-btn" id="fsBtn"><svg ...></svg></button>
    <button class="control-btn" id="helpBtn"><svg ...></svg></button>
  </div>
</nav>
```

---

## 6. Ovládací rozhraní a interakce (`presentation-core.js`)

Prezentace disponují plnohodnotným ovládáním zajištěným z jádra:
- **Klávesnice:**
  - `Šipka vpravo` / `Mezerník` / `PageDown` → Další snímek
  - `Šipka vlevo` / `Backspace` / `PageUp` → Předchozí snímek
  - `Home` / `End` → První / Poslední snímek
  - `F` → Přepnutí celé obrazovky (Fullscreen)
  - `M` nebo `O` → Otevření dynamické osnovy (TOC modál)
  - `T` → Přepnutí světlého a tmavého motivu (synchronizováno do `localStorage` pod klíčem `vos_presentation_theme`)
  - `?` → Modální okno s nápovědou klávesových zkratek
  - `Escape` → Zavření osnovy nebo nápovědy
- **Mobilní zařízení & Dotyk:**
  - Plynulé gesto potažení prstem (Swipe vlevo/vpravo).
- **Trvalé URL kotvy:**
  - Každý krok aktualizuje hash v URL (`#slide-1`, `#slide-2` ...), což umožňuje studentům sdílet přímé odkazy na konkrétní slidy.
- **Dynamická osnova (TOC):**
  - Skript automaticky projde atributy `data-title` nebo nadpisy `h1`/`h2` u všech tagů `.slide` a vygeneruje interaktivní osnovu.

---

## 7. Kontrolní seznam před dokončením modulu

- [ ] Využívá sdílené jádro z `../../assets/css/presentation-core.css` a `../../assets/js/presentation-core.js`.
- [ ] Každá lekce má název souboru podle schématu `XX_[nazev_bez_diakritiky].html`.
- [ ] Všechny soubory jsou propojeny s `index.html` modulu.
- [ ] Všechny ikony jsou inline vektorové SVG s `currentColor` – **žádné emotikony**.
- [ ] Všechny příklady kódu mají funkční tlačítko kopírování do schránky.
- [ ] Kód i ukázky navazují na společnou oborovou doménu předmětu.
- [ ] Slidy obsahují jasné reference na okruhy profilových zkoušek / absolutoria.
- [ ] Prezentace funguje 100% offline bez nutnosti připojení k internetu.
