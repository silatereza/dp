# frozen_string_literal: true

# Úpravy asciidoctor-pdf pro šablonu UHK:
#   * obálka (ink_title_page) podle šablony,
#   * písmo Cambria z cambria.ttc (Prawn umí TTC jen s udáním názvu písma),
#   * čísla oddílů bez koncové tečky (1, 1.1, 1.1.1), titulky "Obrázek 1: Název",
#   * strany příloh (oddíl s rolí .priloha) bez čísla strany.
require 'asciidoctor/extensions'

class Asciidoctor::Section
  alias uhk_sectnum sectnum
  def sectnum delimiter = '.', append = false
    uhk_sectnum delimiter, append
  end
end

module UhkCaptions
  def captioned_title
    return super unless @caption && !@caption.empty?
    %(#{@caption.sub(/\.\s*\z/, ': ')}#{title})
  end
end
Asciidoctor::AbstractBlock.prepend UhkCaptions

class UhkPDFConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  CAMBRIA_FACES = {
    normal: ['cambria.ttc', 'Cambria'],
    bold: ['cambriab.ttf', nil],
    italic: ['cambriai.ttf', nil],
    bold_italic: ['cambriaz.ttf', nil],
  }.freeze

  # Obálka: fakulta a katedra nahoře, název a druh práce, údaje o autorovi, místo a rok dole.
  def ink_title_page doc
    box_h = bounds.height
    font 'Cambria'
    text_box doc.attr('university'), at: [0, box_h], width: bounds.width, align: :center, size: 18
    text_box doc.attr('faculty'), at: [0, box_h - 44], width: bounds.width, align: :center, size: 12
    text_box doc.attr('department'), at: [0, box_h - 68], width: bounds.width, align: :center, size: 12
    text_box doc.doctitle, at: [0, box_h - 220], width: bounds.width, align: :center, size: 18, style: :bold
    text_box doc.attr('thesis-type-lower'), at: [0, box_h - 290], width: bounds.width, align: :center,
      size: 14, style: :italic
    y = box_h - 380
    [
      ['Autor:', doc.attr('author')],
      ['Studijní program:', doc.attr('study-program')],
      ['Studijní obor:', doc.attr('study-field')],
      ['Vedoucí práce:', doc.attr('supervisor')],
    ].each do |label, value|
      text_box label, at: [0, y], width: 130, size: 12
      text_box value.to_s, at: [130, y], width: bounds.width - 130, size: 12
      y -= 28
    end
    text_box doc.attr('city'), at: [0, 14], width: bounds.width / 2, align: :left, size: 12
    text_box doc.attr('thesis-year').to_s, at: [bounds.width / 2, 14], width: bounds.width / 2, align: :right, size: 12
  end

  # Přílohy: číslo strany se nevypisuje.
  def ink_running_content periphery, doc, skip = [1, 1], body_start_page_number = 1
    if periphery == :footer && (appendix = doc.find_by(context: :section) {|sect| sect.role? 'priloha' }.first)
      @disable_running_content[:footer] += (appendix.attr('pdf-page-start').to_i..page_count).to_a
    end
    super
  end

  def register_fonts font_catalog, fonts_dir
    super
    dirs = fonts_dir.split(/;/).reject {|dir| dir.empty? || dir == 'GEM_FONTS_DIR' }
    faces = {}
    CAMBRIA_FACES.each do |style, (file, ttc_name)|
      path = dirs.map {|dir| File.join dir, file }.find {|candidate| File.readable? candidate }
      next unless path
      faces[style] = ttc_name ? { file: path, font: ttc_name } : path
    end
    register_font 'Cambria' => faces unless faces.empty?
  end
end