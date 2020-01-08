require "open-uri"
require "open-uri/cached"
require "nokogiri"

module GcDm
  class RoomHtmlParser
    HOST = "https://wikiwiki.jp/"

    def initialize(path)
      url = HOST + path
      html = open(url).read
      @doc = Nokogiri::HTML.parse(html)
    end

    def get_recipe
      @doc.css("table.style_table tr").each_cons(2) do |tr, next_tr|
        if tr.children[0].text.match("作成レシピ")
          recipe = next_tr.children[0].text.strip[0..-2]
          room_names = recipe.split("+").map(&:strip)
          room_names.each { |n| n[0] = "疫" if n == "役病" }
          return room_names
        end
      end
      return []
    end

    def get_rank
      @doc.css("td.style_td").each do |td|
        if td.text.match("★")
          return td.text.count("★") + 5
        elsif td.text.match("☆")
          return td.text.count("☆")
        end
      end
      raise "Rank not found"
    end
  end
end
