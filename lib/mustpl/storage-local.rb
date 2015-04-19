require 'mustpl/storage-with-root'

module MuStPl
  class LocalStorage < StorageWithRoot
    include Saveable

    def save_s
      "MuStPl::LocalStorage.new(\
#{@name.save_s}, #{@root_dir.save_s}, #{@path_option.save_s})"
    end

    def song_url(song)
      full_song_path(song)
    end

    def path_exist?(path)
      (@root_dir + path).exist?
    end

    # def play(song, player)
    #   player.add_to_playlist(song_url(song))
    # end
  end
end
