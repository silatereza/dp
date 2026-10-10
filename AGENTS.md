# AGENTS.md - diplomová práce (AsciiDoc -> PDF / DOCX)

Návod pro lidi i AI agenty: jak je projekt postavený, jak ho rozběhnout na novém počítači a čeho si dát pozor.
Jazyk práce: čeština (`:lang: cs`). Cílová šablona: `rules/BP_DP_sablona_PrF25_ET.docx` (UHK, Přírodovědecká fakulta).

## Co projekt dělá

Práce se píše v AsciiDoc ve struktuře Antora. Z jednoho hlavního souboru `pdf/dp.adoc` se skládá celá práce
a `asciidoctor-pdf` z ní vytvoří PDF podle šablony UHK. Volitelně vznikne DOCX (přes DocBook a pandoc) a HTML náhled (Antora).

## Struktura

```
dp/
├─ AGENTS.md                      tento soubor
├─ Gemfile                        verze Ruby gemů (viz Instalace)
├─ antora.yml, antora-playbook.yml  Antora (volitelný HTML náhled)
├─ modules/ROOT/                  OBSAH PRÁCE (Antora modul)
│  ├─ nav.adoc                    navigace Antory
│  ├─ pages/                      kapitoly: uvod, teoreticka-vychodiska, cil-prace, metodika, vysledky, diskuze, zaver
│  ├─ partials/
│  │  ├─ metadata.adoc            METADATA PRÁCE (autor, vedoucí, rok, druh práce...) - upravit jako první
│  │  ├─ front/                   zadání, prohlášení, poděkování, anotace (cs + en)
│  │  └─ back/                    seznam literatury, seznam příloh, přílohy
│  ├─ images/                     obrázky (`image::soubor.png[]`)
│  ├─ examples/, attachments/     attachments/ = literatura.bib + iso690-author-date-cs.csl
├─ pdf/                           SESTAVENÍ
│  ├─ dp.adoc                     hlavní dokument: pořadí částí, atributy, sectnums
│  ├─ theme/uhk-theme.yml         vzhled PDF (Cambria 12, A4, okraje, nadpisy, patička)
│  ├─ extensions/uhk-converter.rb obálka, písmo Cambria z .ttc, číslování oddílů, titulky, přílohy bez čísel
│  ├─ extensions/uhk-bibtex-fix.rb oprava bibtex-ruby na Ruby 4 (nutná pro citace)
│  ├─ word/reference.docx, README.adoc  styly pro export DOCX
│  └─ build.ps1                   sestavení
├─ build/                         výstupy (dp.pdf, dp.docx) - necommitovat
├─ podklady/                      pomocné soubory (zdroje, data žáků, poznámky) - v .gitignore, NIKDY necommitovat;
│                                 do práce jen anonymizované výstupy z podklady/data/anonymizovano/
└─ rules/                         zadávací dokumenty UHK (šablona, řád, pokyny k AI) - jen ke čtení
```

Kapitoly (`pages/*.adoc`) začínají `= Název` a do `dp.adoc` se vkládají s `leveloffset=+1`
(`==` uvnitř kapitoly se v práci stane podkapitolou 1.1). Do stránek proto nedávejte `include::partial$...`
ani Antora-only syntaxi, kterou by `asciidoctor-pdf` nepochopil.

## Instalace na novém počítači (Windows)

1. **Ruby 4.0.x** (RubyInstaller s MSYS2), `ruby -v` musí fungovat.
2. V adresáři `dp\`: `bundle install` (nebo ručně `gem install asciidoctor asciidoctor-pdf asciidoctor-bibliography bibtex-ruby csl-styles rouge`).
3. **Písmo Cambria**: Windows ho má v `C:\Windows\Fonts` (`cambria.ttc`, `cambriab.ttf`, `cambriai.ttf`, `cambriaz.ttf`).
   Jiný systém: `.\pdf\build.ps1 -FontsDir cesta` s těmito soubory (nebo upravit `CAMBRIA_FACES` v `uhk-converter.rb`).
4. Volitelně **pandoc** (jen pro DOCX), **Node.js + Antora** (`npx antora antora-playbook.yml`, jen HTML náhled).
5. Zotero + doplněk **Better BibTeX** (viz Citace).

## Sestavení

```powershell
.\pdf\build.ps1          # build\dp.pdf
.\pdf\build.ps1 -Docx    # navíc build\dp.docx (vyžaduje pandoc)
```

Ručně (z adresáře `pdf\`):
`asciidoctor-pdf -r ./extensions/uhk-bibtex-fix.rb -r ./extensions/uhk-converter.rb -a "pdf-fontsdir=C:/Windows/Fonts;GEM_FONTS_DIR" -o ../build/dp.pdf dp.adoc`

## Citace (ČSN ISO 690, Harvard autor-rok)

- Zdroje spravuje Zotero. Better BibTeX automaticky exportuje knihovnu (formát *Better BibTeX*, **Export unicode zapnutý**,
  Keep updated) do `modules/ROOT/attachments/literatura.bib`.
- V textu: `cite:[klic]` (syntaxi více zdrojů a stran viz dokumentace asciidoctor-bibliography, nezkoušeno). Doplněk VS Code *Citation Picker for Zotero*
  musí mít formát vložení `cite:[{key}]`.
- Seznam literatury vzniká z makra `bibliography::[]` v `partials/back/reference.adoc`; styl je `attachments/iso690-author-date-cs.csl`
  (CC BY-SA 3.0, autoři J. Kratochvíl a L. Ansorge). Podle dokumentace gemu se vypisují citované zdroje (ověřeno jen na jednom záznamu).
- Atributy `:bibliography-database:` a `:bibliography-style:` jsou v `pdf/dp.adoc`.

## Zásady a pasti

- **Metadata** (obálka, prohlášení, anotace) jsou jen v `metadata.adoc`. Při změně druhu práce (bakalářská) upravte všechny `thesis-type-*`.
- **Číslování nadpisů** řídí `:sectnums:` / `:sectnums!:` v `pdf/dp.adoc`: Úvod a Závěr nejsou číslované, kapitoly 1-5 ano.
  Nová kapitola patří mezi `:sectnums:` a `:sectnums!:`. Čísla jsou bez koncové tečky (patch v `uhk-converter.rb`).
- **Číslo strany**: obálka a úvodní strany (zadání až obsah) bez čísla, Úvod = fyzická strana 8 (jako v šabloně), přílohy bez čísla
  (oddíl s rolí `[appendix.priloha]`). Pořadí a počet úvodních stran proto neměňte bez kontroly čísla Úvodu.
- **Includy v `dp.adoc` nesmí používat atributy** (`include::{pages}/...`): `asciidoctor-bibliography` je nevyhodnotí. Cesty jsou psané přímo.
- **Ruby 4 a bibtex-ruby 6.0**: bez `uhk-bibtex-fix.rb` generování citací padá (`undefined method 'to_citeproc' for String`).
  Soubor se načítá přepínačem `-r` v `build.ps1`. Po upgradu gemů ověřte, zda oprava ještě potřeba není.
- **Písmo Cambria** je v kolekci `.ttc`; Prawn ho umí jen s udáním názvu (řeší `register_fonts` v `uhk-converter.rb`). Do repozitáře písma nepatří (licence).
- **Obálka** se kreslí ručně v `ink_title_page` (souřadnice v bodech od horního okraje). Úpravy rozložení dělejte tam.
- **Zadání práce** se do PDF nevkládá automaticky, stránka 2 je zástupná; nahraďte ji po vygenerování.
- **Chybí**: automatické seznamy obrázků a tabulek (píší se ručně), posunutí prohlášení a poděkování níže na stránce, vložené římské číslování příloh.
- **DOCX** (`-Docx`) je jednoduchý export: bez obálky a zadání, Úvod a Závěr mají číslo stylu Nadpis 1, citace dělá až `asciidoctor-bibliography`
  (v DOCX tedy už hotový text, ne živé citace). Nezkoušeno na čistém stroji s pandocem.
- Titulky: tabulka nad tabulkou (`.Název`), obrázek pod obrázkem; vypisují se jako "Tabulka 1: Název". Zdroj uvádějte pod titulek ručně.
- Pravidla školy a šablona jsou v `rules/` (řád 10/2026, pokyny k AI, šablona). Šablona vede, vzor `vzor-bp_dp_brezen-2026.docx` je starší (Pedagogická fakulta).

## Kontrola výsledku

```powershell
ruby -e 'require "pdf/reader"; r=PDF::Reader.new("build/dp.pdf"); puts r.page_count; r.pages.each_with_index{|p,i| puts "--- #{i+1}", p.text[0,300]}'
```
Zkontrolujte: obálka (strana 1), číslo Úvodu 8, citace v textu i seznam, přílohy bez čísla, vložené písmo Cambria.