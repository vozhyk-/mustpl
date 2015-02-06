
module MuStPl
  class VKSession
    def initialize(app)
      @a = app
    end

    def get_music (uid = nil)
      res = if uid;  @a.audio.get :owner_id => uid
            else     @a.audio.get
            end
      res["items"]
    end

    def get_songs_by_id(ids)
      @a.audio.get_by_id(audios: ids)
    end
  end

  module VKSong
    def vk_dl_filename_noext
      artist = self["artist"]; title = self["title"]
         oid = self["owner_id"]; aid = self["id"]
      result = "#{artist} - #{title}_#{oid}_#{aid}"
      # replace '/'  -> '-'
      #         '\n' -> ' '
      result.tr("/\n", "- ")
    end

    def vk_dl_filename
      self.vk_dl_filename_noext + ".mp3"
    end
  end

  module VKSongList
  end
end

class Hash
  include MuStPl::VKSong
end

class Array
  include MuStPl::VKSongList
end

class String
  def esc_newlines
    self.tr("\n", " ")
  end
end
