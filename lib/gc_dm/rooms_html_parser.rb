require "open-uri"
require "open-uri/cached"
require "nokogiri"

module GcDm
  class RoomsHtmlParser
    URL = "https://wikiwiki.jp/duma/%E3%83%80%E3%83%B3%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%AE%E9%83%A8%E5%B1%8B"

    def initialize
      html = open(URL).read
      @doc = Nokogiri::HTML.parse(html)
      remove_elements
    end

    def get_rooms
      list = @doc.css("table.style_table tr").map do |tr|
        columns = tr.css("td.style_td")
        name_column = columns[1]
        next unless name_column
        next if name_column.text.start_with?("[")
        next if name_column.text.empty?

        href = columns[1].at_css("a").get_attribute("href")

        Room.new(name_column.text.strip, columns[2].text.strip, href)
      end

      list.compact!
      list
    end

    private

    # Remove needless table tags from `@doc`
    def remove_elements
      marker = false

      @doc.at_css("#body").children.each do |child|
        if child.get_attribute("id") == "h3_content_1_7"
          marker = true
        end
        if marker
          child.remove
        end
      end
    end
  end
end
