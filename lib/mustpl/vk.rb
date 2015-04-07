require 'vk-ruby'

module MuStPl
  class VKSession
    include Saveable

    def initialize(app)
      @a = app
    end

    def save_s
      "MuStPl::VKSession.new(#{@a.save_s})"
    end

    MAX_MSG_GET_COUNT = 200

    def get_music (uid = nil)
      res = if uid;  @a.audio.get :owner_id => uid
            else     @a.audio.get
            end
      res["items"]
    end

    def find_music(text, count: 30)
      @a.audio.search(q: text, count: count)["items"]
    end

    def get_songs_by_id(ids)
      @a.audio.get_by_id(audios: ids)
    end

    # Loads MAX_MSG_GET_COUNT latest "important" messages
    def get_important_messages
      # TODO load more messages using :offset
      @a.messages.get(count: MAX_MSG_GET_COUNT, filters: 8)["items"]
    end
  end

  module VKSong
    def vk_dl_filename_noext
      artist = self["artist"]; title = self["title"]
         oid = self["owner_id"]; aid = self["id"]
      result = "#{artist} - #{title}_#{oid}_#{aid}"
      result.escape_filename
    end

    def vk_dl_filename
      self.vk_dl_filename_noext + ".mp3"
    end
  end

  module VKSongList
  end

  module VKMessageList
    # return messages that have music attached to them
    def with_music
    end
  end
end

class Hash
  include MuStPl::VKSong
end

class Array
  include MuStPl::VKSongList
  include MuStPl::VKMessageList
end

class VK::Application
  include MuStPl::Saveable

  def save_s
    "VK::Application.new(\
app_id: #{@config.app_id.save_s}, \
access_token: #{@config.access_token.save_s}, \
timeout: #{@config.timeout.save_s}, \
open_timeout: #{@config.open_timeout.save_s}, \
)"
  end
end

class String
  def escape_filename
    # replace '/'  -> '-'
    #         '\n' -> ' '
    self.tr("/\n", "- ")
  end

  def escape_newlines
    self.tr("\n", " ")
  end
end
