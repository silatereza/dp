# Působení na klima třídy prostřednictvím digitální hry

Diplomová práce – Univerzita Hradec Králové, Pedagogická fakulta, studijní program Učitelství pro 1. stupeň základních škol.

- **Autorka:** Ing. Tereza Šílová
- **Vedoucí práce:** Mgr. Martin Kaliba, Ph.D.
- **Anglický název:** Influencing Classroom Climate through Digital Games
- **Stav:** rozpracováno (akademický rok 2025/2026)
- **Online náhled:** <https://silatereza.github.io/dp/>

## O práci

Práce se věnuje třídnímu klimatu a jeho ovlivňování pomocí digitálních vzdělávacích her. Jejím cílem je vytvořit
a otestovat digitální výukový program, který simuluje reálné sociální situace a umožňuje žákům rozvíjet sociální
dovednosti. Intervencí je kooperativní webová hra pro dvojice žáků *Strážci světla*, ověřená v jedné třídě
5. ročníku základní školy. Změny klimatu třídy a vztahů mezi žáky byly sledovány sociometrickým šetřením
nástrojem Klima třídy před intervencí a po ní.

## Struktura repozitáře

```
modules/ROOT/            obsah práce (Antora modul)
├─ pages/                kapitoly: úvod, teoretická východiska, cíl práce, metodika, výsledky, diskuze, závěr
├─ partials/front/       zadání, prohlášení, poděkování, anotace
├─ partials/back/        seznam literatury, seznam příloh, přílohy
├─ attachments/          literatura.bib a citační styl ČSN ISO 690
└─ nav.adoc              navigace webového náhledu
pdf/                     sestavení PDF (hlavní dokument dp.adoc, vzhled podle šablony UHK, rozšíření)
rules/                   pravidla a šablony UHK (jen ke čtení)
.github/                 automatické zveřejnění webového náhledu (GitHub Pages)
```

Podrobný technický popis projektu (instalace, sestavení, citace, známé pasti) je v [AGENTS.md](AGENTS.md).

## Sestavení

Práce je psaná v [AsciiDoc](https://asciidoc.org/) ve struktuře [Antora](https://antora.org/).

```powershell
bundle install           # Ruby gemy (asciidoctor-pdf, asciidoctor-bibliography…)
.\pdf\build.ps1          # build\dp.pdf
.\pdf\build.ps1 -Docx    # navíc build\dp.docx (vyžaduje pandoc)
```

Webový náhled se sestavuje automaticky po každém pushi do větve `main`.

## Data a ochrana osobních údajů

Repozitář je veřejný, proto **neobsahuje žádná data žáků**. Podkladové materiály (sociometrické reporty, export ze hry,
klíč k pseudonymizaci, pracovní poznámky) jsou uloženy pouze lokálně ve složce `podklady/`, která je vyřazena z gitu.
V textu práce jsou žáci uváděni pouze pod kódy (Z01–Z27); název školy ani obce se v práci neuvádí.

## Využití nástrojů umělé inteligence

Při přípravě práce a vývoji hry byly využity nástroje umělé inteligence. Jejich přehled v souladu s pokynem
UHK č. 01/2024 je uveden v kapitole Metodika (podkapitola Využití nástrojů umělé inteligence).

## Poděkování

Za technické vedení a návrh použitých nástrojů (Antigravity, Claude Code, Firebase, GitHub Pages, AsciiDoc)
děkuji Ing. Jiřímu Šílovi.
