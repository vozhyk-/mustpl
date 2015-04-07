require 'delegate'

module MuStPl
  class SongList < DelegateClass(Array)
    include Saveable

    attr_accessor :name
    # Comparison of SongLists will not look at their names

    def initialize(name, list)
      @name = name
      super(list)
    end

    def [](i)
      if i.is_a? Range
        self.class.new(name, super)
      else
        super
      end
    end
    # TODO Override map to return a SongList
    def shuffle; self.class.new(name, super); end
    def select; self.class.new(name, super); end

    def save_s
      "MuStPl::SongList.new(#{@name.save_s}, #{super})"
    end

    def filename
      @name.escape_filename + DataFileExt
    end

    # working version must support:
    #  append/prepend song to list

    def to_m3u_s (user, prio)
      M3U::new_m3u_s(
        map { |s| s.to_m3u_entry(user, prio) })
    end

    def to_m3u (user, prio, file)
      open(file, "w") do |f|
        f << to_m3u_s(user, prio)
      end
    end
  end
end
