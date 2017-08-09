require "tungsten/version"
require "tungsten/dsl"
require "tungsten/library"
require "tungsten/role"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.rb',
    tungfile: 'Tungfile'
  }

  class << self
    include Tungsten::DSL

    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end

    def servers
      @servers ||= []
    end

    def libraries
      @libraries ||= {}
    end

    def roles
      @roles ||= {}
    end

    def load!
      if File.exists?(options[:config_file])
        eval(File.open(options[:config_file], 'r').read)
      end
    end

    def servers_iteration(&block)
      roles.keys.each do |role|
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

    def install!
      puts "Execute server installation"
      servers_iteration do |server, role|
        server.install!
      end
    end

    def register_server(address, options)
      servers << Server.new(address, options)
    end

    def register_library(name)
      if library_registered?(name)
        puts "Library with name '#{name}' already exists!"
        return nil
      end
      library = Library.new(name)
      libraries[name] = library
      library
    end

    def library_registered?(library_name)
      return !Tungsten.libraries[name].nil?
    end

    def get_library(library_name)
      Tungsten.libraries[name]
    end

    def register_role(name)
      if role_registered?(name)
        puts "Library with name '#{name}' already exists!"
        return nil
      end
      role = Role.new(name)
      roles[name] = role
      role
    end

    def role_registered?(role_name)
      return !roles[name].nil?
    end

    def get_role(role_name)
      roles[name]
    end
  end
end
