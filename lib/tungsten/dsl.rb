require 'tungsten/server'

module Tungsten
  class DSL
    class << self
      @servers = []

      def server(address, *options)
        @servers << Server.new(address, {pending: true})
      end
    end
  end
end
