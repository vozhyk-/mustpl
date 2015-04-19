require 'pathname'

module MuStPl
  class StorageWithRoot < Storage
    attr_accessor :root_dir, :path_option

    def initialize(name, root_dir, path_option)
      super(name)
      @root_dir = Pathname.new root_dir
      @path_option = path_option
    end

    # save_s must still be implemented by subclass

    def full_song_path(song)
      (@root_dir + song_path(song)).to_s
    end

    def song_path(song)
      song[@path_option]
    end

    def set_song_path(song, path)
      song[@path_option] = path
    end
  end
end
