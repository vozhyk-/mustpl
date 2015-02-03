
module MuStPl
  class User
    attr_accessor :storage

    def initialize
      @storage = {}
    end

    def find_storage(name); @storage[name]; end
  end

  class StreamStorage
    attr_accessor :name
  end

  class LocalStreamStorage < StreamStorage
    attr_accessor :storage_dir, :local_path_option

    # def play(song, player)
    #   full_path = @storage_dir + song[@local_path_option]
    #   player.add_to_playlist(full_path)
    # end
  end

  class Song
    attr_accessor :info, :storage

    # TODO
    #  convert_storage

    def initialize(*info)
      @info = info.last
    end

    def [](key); @info[key]; end
    def []=(key, value); @info[key] = value; end

    def to_m3u_entry(user)
      st = self[:storage][0]
      storage = user.find_storage(st)
      storage.to_m3u_entry(self)
    end
  end

  class SongList
    attr_accessor :list

    def initialize(list)
      @list = list
    end

    def [](i); @list[i]; end
    def []=(i, value); @list[i] = value; end

    # working version must support:
    #  to_m3u
    #  append/prepend song to list

    def to_m3u_s (user)
      M3U::new_m3u_s(
        @list.map { |s| s.to_m3u_entry(user) })
    end

    def to_m3u (user, file)
      open(file, "w") do |f|
        f << to_m3u_s(user)
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
