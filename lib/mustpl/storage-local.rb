require 'pathname'

module MuStPl
  class LocalStorage < Storage
    attr_accessor :storage_dir, :local_path_option

    def initialize(name, storage_dir, local_path_option)
      super(name)
      @storage_dir = Pathname.new storage_dir
      @local_path_option = local_path_option
    end

    def song_url(song)
      (@storage_dir + song_path(song)).to_s
    end

    def path_exist?(path)
      (@storage_dir + path).exist?
    end

    def song_path(song)
      song[@local_path_option]
    end

    # def play(song, player)
    #   full_path = @storage_dir + song[@local_path_option]
    #   player.add_to_playlist(full_path)
    # end
  end
end
