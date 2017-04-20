require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

module Tungsten
  class Server
    attr_accessor :address

    def initialize(address:, options:{})
      @address = address
      @options = options
    end

    def type
      options[:type]
    end

    def execute(command)
      
    end
  end
end
