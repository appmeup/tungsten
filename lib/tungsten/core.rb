require "tungsten/library"
require "tungsten/role"
require "tungsten/server"

module Tungsten
  module Core
    def servers
      @servers ||= []
    end

    def libraries
      @libraries ||= {}
    end

    def roles
      @roles ||= {}
    end

    # Load Tungsten's configuration
    def load!
      if Dir.exists?(options[:libraries_directory])
        Dir.glob("#{options[:libraries_directory]}/*.rb").each do |file|
          eval(File.open(file, 'r').read)
        end
      end
      if File.exists?(options[:config_file])
        eval(File.open(options[:config_file], 'r').read)
      end
    end

    # Returns a block that iterates over each server's role
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

    # For each server: install, setup and run each library used by its role
    def install!
      servers_iteration do |server, role|
        server.execute!(:install)
        server.execute!(:setup)
        server.execute!(:run)
      end
    end

    # Register a server
    def register_server(address, options)
      servers << Server.new(address, options)
    end

    # Register a library
    def register_library(name)
      if library_registered?(name)
        puts "Library with name '#{name}' already exists!"
        return nil
      end
      library = Library.new(name)
      libraries[name] = library
      library
    end

    # Check if a library was already registered
    def library_registered?(library_name)
      return !Tungsten.libraries[name].nil?
    end

    # Obtain an already registered library
    def get_library(library_name)
      Tungsten.libraries[name]
    end

    # Register a new role
    def register_role(name)
      if role_registered?(name)
        puts "Role with name '#{name}' already exists!"
        return nil
      end
      role = Role.new(name)
      roles[name] = role
      role
    end

    # Check if a role was already registered
    def role_registered?(role_name)
      return !roles[name].nil?
    end

    # Obtain an already registered role
    def get_role(role_name)
      roles[name]
    end
  end
end
