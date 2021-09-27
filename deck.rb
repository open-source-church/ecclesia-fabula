require 'squib'
require 'game_icons'

#https://espritdepays.com/bonus/glossaire-architecture-religieuse

data = Squib.csv file: 'cartes.csv', col_sep: ",", quote_char: '"'

DEFAULT_ICON = "Uncertainty"
COLOR_ELEMENT = "#000055"
COLOR_THEME = "#005500"

Squib::Deck.new(cards: data["Type"].size, layout: 'layout.yml', width: "68mm", height: "93mm") do
  background color: '#502d16'
  
  #hint text: "lightgray"
  
  #rect layout: 'cut'
  
  data["Type"].each_with_index do |type, r|
    case type
    when "Titre"
      svg range: r, data: GameIcons.get(data["Icone"][r] || DEFAULT_ICON).recolor(fg: '#fff', bg: '#502d16').string, layout: "icone", width: :scale
      text range: r, str: data["Titre"][r], layout: "text", color: "white", valign: "middle", font_size: 24, font: "Code Pro Light", align: "center"
      
    when "Règles"
      rect range: r, layout: "background"
      txt = data["Description"][r].gsub("\\n", "\n").gsub(/\*\*(.*?)\*\*/, '<span  foreground="#502d16" font_desc="Code Pro Light 12">\1</span>')
      txt = txt.gsub(/\*(.*?)\*/, '<span foreground="#502d16">\1</span>')
      text range: r, layout: "regles", str: txt, font: "Ubuntu, 10", markup: true
      
    when "Architecture"
      background range: r, color: COLOR_ELEMENT
      
      rect range: r, layout: "background"
      
      #Icone
      if data["Icone"][r] and data["Icone"][r].include? "Eglise-"
        name = data["Icone"][r][7..]
        png range: r, file: "img/#{name}.png", layout: "icone", width: :scale
      elsif data["Icone"][r]
        svg range: r, data: GameIcons.get(data["Icone"][r]).recolor(fg: COLOR_ELEMENT, bg: 'fff').string, layout: "icone", width: :scale
      else
        svg range: r, data: GameIcons.get(DEFAULT_ICON).recolor(fg: 'ccc', bg: 'fff').string, layout: "icone", width: :scale
      end
      
      #Text
      text range: r, str: data["Titre"][r], layout: "titre"
      text range: r, str: data["Description"][r], layout: "text"
      
    when "Thème"
      background range: r, color: COLOR_THEME
      rect range: r, layout: "background"
      
      #Icone
      if data["Icone"][r]
        svg range: r, data: GameIcons.get(data["Icone"][r]).recolor(fg: COLOR_THEME, bg: 'fff').string, layout: "icone", width: :scale
      else
        svg range: r, data: GameIcons.get(DEFAULT_ICON).recolor(fg: 'ccc', bg: 'fff').string, layout: "icone", width: :scale
      end
      
      #Text
      text range: r, str: data["Titre"][r], layout: "titre"
      text range: r, str: data["Description"][r], layout: "text"
      
    end
  end
  
  #save format: :png
  save_pdf file: "cards.pdf", trim: "2mm", height: "297mm", width: "210mm"
  #showcase file: "showcase.png", range: 0..6
end
