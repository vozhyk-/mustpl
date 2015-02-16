require 'delegate'

module MuStPl
  class Song < DelegateClass(Hash)
    include Saveable

    def save_s
      "MuStPl::Song.new(#{super})"
    end

    def add_storage name
      self[:storage] << name unless self[:storage].include? name
    end

    def to_m3u_entry(collection, prio)
      st = prio.find { |st| self[:storage].include? st }
      storage = collection.find_storage(st)

      # TODO add album? move into method?
      info = "#{self[:artist]} - #{self[:title]}"

      M3U::new_m3u_entry(
        storage.song_url(self),
        self[:duration],
        info)
    end
  end
end
