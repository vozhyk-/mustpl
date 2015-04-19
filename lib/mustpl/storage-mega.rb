require 'mustpl/storage-with-root'
require 'cgi' # for CGI.escape

module MuStPl
  class MEGAStorage < StorageWithRoot
    include Saveable

    attr_accessor :mega_s, :email, :server

    def initialize(name,
                   email:, mega_storage:,
                   server: "localhost:8080",
                   root:, path_option:)
      super(name, root, path_option)
      @email = email
      @mega_s = mega_storage
      @server = server

      @url_prefix = "http://#{server}/#{email}/"
    end

    def save_s
      "MuStPl::MEGAStorage.new(\
#{@name.save_s}, \
email: #{@email.save_s}, \
mega_storage: #{@mega_s.save_s}, \
server: #{@server.save_s}, root: #{@root_dir.save_s}, \
path_option: #{@path_option.save_s})"
    end

    def song_url(song)
      # TODO don't escape path separators ('/').
      #      Even though megahttp works anyway
      @url_prefix + CGI.escape(full_song_path(song))
    end

    def path_exist?(path)
      true #stub
    end
  end
end
