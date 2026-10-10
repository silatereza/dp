# frozen_string_literal: true

# Oprava kompatibility asciidoctor-bibliography 0.11 + bibtex-ruby 6.0 na Ruby 4:
#  1. BibTeX::Entry#parse_names (volá se při převodu na CSL) mění jména autorů na řetězce
#     a generování citací pak spadne ("undefined method to_citeproc for String");
#     parser je přitom při načtení souboru už vytvořil, takže stačí tento krok vynechat,
#  2. LaTeX filtr z asciidoctor-bibliography převádí jména autorů na řetězce,
#     proto databázi čteme bez něj. Soubor .bib musí být v UTF-8 (Better BibTeX: "Export unicode").
require 'bibtex'
require 'asciidoctor-bibliography'

module BibTeX
  class Entry
    def parse_names
      self
    end
  end

  class Bibliography
    def parse_names
      self
    end
  end
end

module AsciidoctorBibliography
  module Databases
    module BibTeX
      def self.load filename
        ::BibTeX.open(filename).to_citeproc
      end
    end
  end
end