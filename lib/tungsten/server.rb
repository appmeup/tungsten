module Tungsten
  class Server
    attr_accessor :address

    def initialize(address, options={})
      @address = address
      @options = options
    end

    def roles
      @options[:roles]
    end

    def has_role?(role)
      self.roles.include?(role.to_s) rescue false
    end

    def ssh_options
      return {
        user: @options[:user],
        keys: [@options[:key]].flatten
      }
    end

    def has_custom_ssh?
      options.has_key?(:user) || options.has_key?(:key)
    end

    def install!
      server_roles = []
      Tungsten.roles.keys.each do |role|
        server_roles << Tungsten.roles[role] if roles.include?(role)
      end
      unique_libraries = []
      server_roles.each do |role|
        unique_libraries << role.libraries
      end
      unique_libraries.flatten!.uniq!
      server_libraries = []
      Tungsten.libraries.keys.each do |library|
        server_libraries << Tungsten.libraries[library]
      end
      server_libraries.each do |library|
        library.execute_phase!(:install, self)
      end
    end
  end
end
