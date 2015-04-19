module MuStPl
  class VKStorage < Storage
    include Saveable

    attr_accessor :vk_s

    AppID = 3310267

    def initialize (name, vk_session)
      super(name)
      @vk_s = vk_session
    end

    def save_s
      "MuStPl::VKStorage.new(#{@name.save_s}, #{@vk_s.save_s})"
    end

    def song_url(song)
      song[:vk_song]["url"]
    end

    def self.link_to_local_storage!(list, storage)
      list.each do |s|
        VKStorage.link_song_to_local_storage(s, storage)
      end
    end

    def self.link_song_to_local_storage(s, storage)
      filename = s[:vk_song].vk_dl_filename
      if storage.path_exist? filename
        s.add_storage storage.name
        storage.set_song_path(s, filename)
      end
    end

    def import(name, songs)
      MuStPl::SongList.new(
        name,
        songs.map { |s| import_song(s) }
      )
    end

    def import_song(vk_song)
      s = vk_song
      MuStPl::Song.new(
        storage:     [@name],
        vk_song:     s,

        artist:      s["artist"].escape_newlines,
        title:       s["title"].escape_newlines,
        duration:    s["duration"],

        # TODO download lyrics
        # TODO genre_id
      )
    end

    # Reload :vk_song data from vk
    def reload_song!(song)
      song[:vk_song] = vk_get_song(song)
    end

    # The same but for a SongList
    # You may need to run it before converting to m3u using this storage
    def reload_songs!(songs)
      vk_ids = songs.map { |x| VKStorage.vk_id_s x }
      vk_songs = @vk_s.get_songs_by_id(vk_ids)
      songs.zip(vk_songs) do |s, v| s[:vk_song] = v; end
    end

    def vk_get_song(song)
      @vk_s.get_songs_by_id(VKStorage.vk_id_s(song))\
        .first
    end

    def self.vk_id_s(song)
      "#{song[:vk_song]['owner_id']}_#{song[:vk_song]['id']}"
    end
  end

  class Song
    def vk_reload!(storage)
      storage.reload_song! self
    end
  end

  class SongList
    def vk_reload!(storage)
      storage.reload_songs! self
    end
  end
end
