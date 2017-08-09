module Tungsten
  class Variable
    def initialize(key, value, description = 'No description')
      @key = key
      @value = value
      @description = description
    end

    def key
      @key
    end

    def value
      @value
    end

    def description
      @description
    end

    def to_h
      {
        key: @key,
        value: @value,
        description: @description
      }
    end
  end
end
