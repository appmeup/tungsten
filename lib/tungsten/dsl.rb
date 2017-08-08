require 'tungsten/server'
require 'sshkit'
require 'sshkit/dsl'

module Tungsten
  module DSL
    include SSHKit::DSL
    attr_accessor :servers
    attr_accessor :execution_commands
    attr_accessor :installation_commands

    def server(address, options)
      @servers ||= []
      @servers << Server.new(address, options)
    end

    def roles
      roles_array = []
      @servers.each do |server|
        server.roles.each do |role|
          roles_array << role if !roles_array.include?(role)
        end
      end
      roles_array
    end

    def execution(role, &block)
      @execution_commands ||= {}
      @execution_commands[role.to_s] = block if block_given?
    end

    def installation(role, &block)
      @installation_commands ||= {}
      @installation_commands[role.to_s] = block if block_given?
    end
  end
end
