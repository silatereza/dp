<#
.SYNOPSIS
  Sestaví diplomovou práci z AsciiDoc zdrojů (Antora struktura) do PDF a volitelně DOCX.
.EXAMPLE
  .\build.ps1            # PDF -> ..\build\dp.pdf
  .\build.ps1 -Docx      # navíc DOCX (vyžaduje pandoc)
#>
param(
  [switch]$Docx,
  [string]$FontsDir = 'C:/Windows/Fonts'   # musí obsahovat cambria.ttc, cambriab.ttf, cambriai.ttf, cambriaz.ttf
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$out = Join-Path (Split-Path $here -Parent) 'build'
New-Item -ItemType Directory -Force $out | Out-Null

Push-Location $here
try {
  asciidoctor-pdf -r ./extensions/uhk-bibtex-fix.rb -r ./extensions/uhk-converter.rb `
    -a "pdf-fontsdir=$FontsDir;GEM_FONTS_DIR" `
    -o (Join-Path $out 'dp.pdf') dp.adoc
  if ($LASTEXITCODE) { throw 'asciidoctor-pdf selhal' }
  Write-Host "PDF: $out\dp.pdf"

  if ($Docx) {
    # DocBook -> DOCX se styly ze šablony (word\reference.docx, viz word\README.adoc)
    asciidoctor -r ./extensions/uhk-bibtex-fix.rb -b docbook5 -a docx -o (Join-Path $out 'dp.xml') dp.adoc
    if ($LASTEXITCODE) { throw 'asciidoctor (docbook) selhal' }
    pandoc (Join-Path $out 'dp.xml') -f docbook -t docx --toc --toc-depth=3 `
      --reference-doc word/reference.docx -o (Join-Path $out 'dp.docx')
    if ($LASTEXITCODE) { throw 'pandoc selhal' }
    Write-Host "DOCX: $out\dp.docx"
  }
} finally { Pop-Location }