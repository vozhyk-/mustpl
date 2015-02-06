module MuStPl
  module Saveable
    def save(filename)
      File.open(filename, 'w') do |f|
        f.print self.save_s
      end
    end
  end

  def self.load(filename)
    eval(File.read filename)
  end

  class Song
    def save_s
      "MuStPl::Song.new(#{@info.save_s})"
    end
  end

  class SongList
    def save_s
      "MuStPl::SongList.new(#{@list.save_s})"
    end
  end
end

class Object
  include MuStPl::Saveable

  # Returns a string representation that can be read back later
  def save_s; inspect; end
end

class Array
  def save_s
    "[" + map(&:save_s).join(", ") + "]"
  end
end
