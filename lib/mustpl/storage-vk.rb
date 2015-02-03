module MuStPl
  class VKStreamStorage < StreamStorage
    attr_accessor :vk_s

    AppID = 3310267

    def initialize (vk_session)
      @vk_s = vk_session
    end

    def to_m3u_entry(song)
      # TODO add album? move into method?
      info = "#{song[:artist]} - #{song[:title]}"

      M3U::new_m3u_entry(
        song[:vk_song]["url"],
        song[:duration],
        info)
    end

    def reload_vk_song(song)
      song[:vk_song] = vk_get_song(song)
    end

    # You may need to run it before converting to m3u using this class
    # needs more testing, just hope it works for now
    def reload_vk_songs(songs)
      vk_ids = songs.list.map { |x| VKStreamStorage.vk_id_s x }
      vk_songs = @vk_s.get_songs_by_id(vk_ids)
      songs.list.zip(vk_songs) do |s, v| s[:vk_song] = v; end
    end

    def vk_get_song(song)
      @vk_s.get_songs_by_id(VKStreamStorage.vk_id_s(song))\
        .first
    end

    def self.vk_id_s(song)
      "#{song[:vk_song]['owner_id']}_#{song[:vk_song]['id']}"
    end
  end
end
