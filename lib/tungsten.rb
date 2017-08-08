require "tungsten/version"
require "tungsten/dsl"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.rb',
  }

  class << self
    include Tungsten::DSL

    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end

    def load!
      if File.exists?(options[:config_file])
        eval(File.open(options[:config_file], 'r').read)
      end
    end

    def servers_iteration(&block)
      roles.each do |role|
        @servers.each do |server|
          if server.roles.include?(role)
            SSHKit::Backend::Netssh.configure do |ssh|
              ssh.ssh_options = server.ssh_options
            end
            yield server, role
          end
        end
      end
    end

    def execute!
      puts "Execute server commands"
      servers_iteration do |server, role|
        execution_commands = @execution_commands[role]
        if execution_commands
          execution_commands.yield(server)
        else
          puts "No execution commands found for role: #{role}"
        end
      end
    end

    def install!
      puts "Execute server installation"
      servers_iteration do |server, role|
        installation_commands = @installation_commands[role]
        if installation_commands
          installation_commands.yield(server)
        else
          puts "No installation commands found for role: #{role}"
        end
      end
    end
  end
end
