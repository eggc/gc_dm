module GcDm
  class Room < Struct.new(:name, :description, :href, :materials, :rank)
    # この部屋を作成するのに必要なアトムの総数を返す
    # @return [Hash] キーがアトムの名前、値が部屋の数
    def atoms
      if materials && !materials.empty?
        materials.each_with_object({}) do |material, result|
          material.atoms.each do |k, v|
            result[k] = result[k].to_i + v
          end
        end
      else
        { self.name => 1 }
      end
    end
  end
end
