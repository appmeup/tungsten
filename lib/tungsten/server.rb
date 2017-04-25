require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

module Tungsten
  class Server
    attr_accessor :address

    def initialize(address, options={})
      @address = address
      @options = options
    end

    def roles
      options[:roles]
    end

    def has_role?(role)
      options[:roles].include?(role) rescue false
    end

    def execute(command)

    end
  end
end
