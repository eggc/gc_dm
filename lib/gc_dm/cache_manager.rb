module GcDm
  class CacheManager
    CACHE_PATH = "/tmp/gcdm-cache"

    def self.load
      cache = File.read(CACHE_PATH)
      Marshal.load(cache)
    end

    def self.save(object)
      File.open(CACHE_PATH, "wb") do |f|
        f.write(Marshal.dump(object))
      end
    end
  end
end
