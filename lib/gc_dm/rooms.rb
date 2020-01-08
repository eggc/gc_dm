module GcDm
  class Rooms
    def initialize(rooms = [])
      @rooms = rooms
    end

    def load
      parser = RoomsHtmlParser.new
      @rooms = parser.get_rooms
      @rooms.each do |room|
        parser = RoomHtmlParser.new(room.href)
        room.rank = parser.get_rank
        recipe = parser.get_recipe
        room.materials = recipe.map do |material_name|
          find(material_name)
        end
        sleep(1)
      end
      self
    end

    def find(name)
      @rooms.find { |room| room.name == name } || raise("#{name} is not found")
    end

    def filter_by(rank:)
      items = @rooms.select {|room| room.rank == rank }
      Rooms.new(items)
    end

    def to_s
      @rooms.map(&:to_s)
    end
  end
end
