
module MuStPl
  class User
    attr_accessor :storage

    def initialize
      @storage = {}
    end

    def add_storage(st)
      @storage[st.name] = st
    end

    def find_storage(name); @storage[name]; end
  end

  class Storage
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end

  class Song
    attr_accessor :info

    # TODO
    #  convert_storage

    def initialize(*info)
      @info = info.last
    end

    def ==(other)
      other.is_a?(self.class) && @info == other.info
    end
    def [](key); @info[key]; end
    def []=(key, value); @info[key] = value; end

    def add_storage name
      @info[:storage] << name unless @info[:storage].include? name
    end

    def to_m3u_entry(user, prio)
      st = prio.find { |st| self[:storage].include? st }
      storage = user.find_storage(st)

      # TODO add album? move into method?
      info = "#{self[:artist]} - #{self[:title]}"

      M3U::new_m3u_entry(
        storage.song_url(self),
        self[:duration],
        info)
    end
  end

  class SongList
    attr_accessor :list

    def initialize(list)
      @list = list
    end

    def ==(other)
      other.is_a?(self.class) && @list == other.list
    end
    def [](i)
      if i.is_a? Range
        SongList.new(list[i])
      else
        @list[i]
      end
    end
    def []=(i, value); @list[i] = value; end
    def each(&block); @list.each(&block); end

    # working version must support:
    #  append/prepend song to list

    def to_m3u_s (user, prio)
      M3U::new_m3u_s(
        @list.map { |s| s.to_m3u_entry(user, prio) })
    end

    def to_m3u (user, prio, file)
      open(file, "w") do |f|
        f << to_m3u_s(user, prio)
      end
    end
  end

  module M3U
    def self.new_m3u_s(entries)
      "#EXTM3U\n" + entries.join('')
    end

    def self.new_m3u_entry(url, duration, info)
"#EXTINF:#{duration},#{info}
#{url}
"
    end
  end
end
