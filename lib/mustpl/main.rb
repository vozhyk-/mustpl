require 'delegate'

module MuStPl
  DataFileExt = ".rb"

  class Storage
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    # Subclass must provide:
    #   save_s
    #   song_url
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
