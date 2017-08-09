module Tungsten
  class Role
    def initialize(name)
      @name = name
      @libraries = {}
    end

    def libraries
      @libraries
    end

    def uses(library_name, args={})
      @libraries[library_name] = args unless @libraries.keys.include?(library_name)
    end
  end
end
