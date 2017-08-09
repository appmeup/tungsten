module Tungsten
  class Role
    def initialize(name)
      @name = name
      @library_names = []
    end

    def libraries
      @library_names
    end

    def uses(library_name)
      @library_names << library_name unless @library_names.include?(library_name)
    end
  end
end
