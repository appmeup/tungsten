require "tungsten/library"
require "tungsten/role"
require "tungsten/server"
require 'fileutils'

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

    ###################
    # CLI comamnds
    ###################

    def init!
      # Initialize Tungsten by creating the config file
      if File.exists?('config/tungsten.rb')
        puts "[WARN] Tungsten config file already exists"
      else
        if !Dir.exists?('config')
          Dir.mkdir('config')
        end
        FileUtils.cp(File.expand_path("../templates/tungsten.rb", __FILE__), 'config/tungsten.rb')
        puts "Tungsten config file created at: config/tungsten.rb"
      end
    end

    # For each server: install, setup and run each library used by its role
    def install!
      servers_iteration do |server, role|
        server.execute!(:install)
      end
    end

    def setup!
      servers_iteration do |server, role|
        server.execute!(:setup)
      end
    end

    def start!
      servers_iteration do |server, role|
        server.execute!(:start)
      end
    end

    def stop!
      servers_iteration do |server, role|
        server.execute!(:stop)
      end
    end

    def check!
      servers_iteration do |server, role|
        server.execute!(:check)
      end
    end

    def restart!
      servers_iteration do |server, role|
        server.execute!(:stop)
        server.execute!(:run)
      end
    end

    def uninstall!
      servers_iteration do |server, role|
        server.execute!(:stop)
        server.execute!(:uninstall)
      end
    end

    def display_libs!
      puts "Tungsten libraries:"
      if libraries.keys.size === 0
        puts "No libraries available"
      else
        puts libraries.keys.join(', ')
      end
    end

    def display_lib_info!(library_name)
      lib = libraries[library_name.to_sym]
      puts lib.name
      puts(lib.get_metadata[:description]) if lib.get_metadata[:description]
      puts "----------------------"
      puts "Locked at version: #{lib.get_metadata[:lock] || "Not locked"}"
      puts "----------------------"
      puts "Phases"
      puts lib.phases.keys.join(', ')
      puts "----------------------"
      puts "Variables"
      variables = lib.variables.to_h
      variables.keys.each do |key|
        variable = lib.variables[key]
        puts "#{variable.key} = #{variable.value} | #{variable.description}"
      end
    end

    def display_servers!
      puts "Tungsten Servers"
      if servers.size === 0
        puts "No servers configured"
      else
        puts "[Roles]: Address"
        puts "-----------------"
        servers.each do |server|
          puts "[#{server.roles.join(', ')}]: #{server.address}"
        end
      end
    end

    def display_roles!
      puts "Tungsten Roles"
      if roles.size === 0
        puts "No roles created"
      else
        puts "[Role]: Libraries"
        puts "-----------------"
        roles.keys.each do |role|
          libraries = roles[role].libraries.keys
          if libraries.size === 0
            puts "[#{role}]: No libraries associated"
          else
            puts "[#{role}]: #{libraries.join(', ')}"
          end
        end
      end
    end

    def display_role!(role_name)
      role = roles[role_name.to_sym]
      if role
        libraries = role.libraries.keys
        puts "Role: #{role_name}"
        puts "----------------------"
        puts "Libraries"
        if libraries.size === 0
          puts "No libraries associated"
        else
          puts "#{libraries.join(', ')}"
        end
      else
        puts "Role #{role_name} not found"
      end
    end

    ############################
    # Registration methods
    ############################

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
