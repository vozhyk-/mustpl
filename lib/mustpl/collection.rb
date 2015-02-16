module MuStPl
  class SongCollection
    include Saveable
    extend Loadable

    attr_accessor :root, :storage, :lists

    def initialize(root_path, storage = [])
      @root = Pathname.new(root_path)
      @storage = Hash[storage.map{ |s| [s.name, s] }]
      @lists = {}
      read_lists
    end

    def save_s
      "MuStPl::SongCollection.new(#{@root.save_s}, #{@storage.values.save_s})"
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
