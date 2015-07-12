module MuStPl
  class SongCollection
    include Saveable
    extend Loadable

    attr_accessor :root, :storage, :storage_prio, :lists

    def initialize(root_path, storage = [], storage_prio = nil)
      @root = Pathname.new(root_path)
      @storage = Hash[storage.map{ |s| [s.name, s] }]
      @storage_prio = storage_prio or @storage.map(&:first)
      @lists = {}
      read_lists
    end

    def save_s
      "MuStPl::SongCollection.new(#{@root.save_s}, #{@storage.values.save_s}, #{stogare_prio.save_s})"
    end

    def lists_a
      lists.values
    end

    def add_storage(st)
      @storage[st.name] = st
    end

    def find_storage(name); @storage[name]; end

    SaveBasename = "collection#{DataFileExt}"

    def save_filename
      @root + SaveBasename
    end

    def self.load_filename path
      Pathname.new(path) + SaveBasename
    end

    def lists_path
      @root + "lists"
    end

    def add_list list
      # TODO check if not overwriting existing list
      list.save(lists_path + list.filename)
      put_list list
    end

    def put_list list
      @lists[list.name] = list
    end

    def read_lists
      Dir.glob(lists_path + "*#{DataFileExt}").each do |file|
        put_list(MuStPl::load file)
      end
    end
  end
end
