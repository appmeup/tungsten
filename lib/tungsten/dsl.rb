require 'tungsten/server'

module Tungsten
  module DSL
    attr_accessor :servers

    def server(address, *options)
      @servers ||= []
      @servers << Server.new(address, options)
    end
  end
end
