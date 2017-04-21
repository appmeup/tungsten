require 'tungsten/server'

module Tungsten
  module DSL
    attr_accessor :servers
    @servers = []

    def server(address, *options)
      @servers << Server.new(address, options)
    end
  end
end
