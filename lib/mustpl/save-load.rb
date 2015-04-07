module MuStPl
  module Saveable
    def save(filename = save_filename)
      File.open(filename, 'w') do |f|
        f.print self.save_s
      end
    end
  end

  module Loadable
    def load(path)
      if File.directory?(path)
        self.load load_filename(path)
      else
        MuStPl::load path
      end
    end
  end

  def self.load(filename)
    eval(File.read filename)
  end
end

class Object
  include MuStPl::Saveable

  # Returns a string representation that can be read back later
  def save_s; inspect; end
end

class Pathname
  def save_s
    "Pathname.new(#{to_s.save_s})"
  end
end

class Array
  def save_s
    "[" + map(&:save_s).join(", ") + "]"
  end
end

# class Hash
#   def save_s
#     "{" + map{ |key, value| "#{key.save_s}=>#{value.save_s}" }\
#           .join(", ") \
#     + "}"
#   end
# end
