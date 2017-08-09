module Tungsten
  class Server
    attr_accessor :address

    def initialize(address, options={})
      @address = address
      @options = options
      @libraries = []
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

    def libraries
      if !@libraries.empty?
        return @libraries
      end

      return self.load_libraries
    end

    def load_libraries
      server_roles = []
      unique_libraries = {}

      Tungsten.roles.keys.each do |role|
        server_roles << Tungsten.roles[role] if roles.include?(role)
      end

      server_roles.each do |role|
        role.libraries.keys.each do |library_name|
          unique_libraries[library_name] = role.libraries[library_name] if !unique_libraries.keys.include?(library_name)
        end
      end

      Tungsten.libraries.keys.select{|library_name| unique_libraries.keys.include?(library_name) }.each do |library_name|
        library = Tungsten.libraries[library_name].dup
        library.merge_args(unique_libraries[library_name])
        @libraries << library
      end

      return @libraries
    end

    def execute!(phase)
      libraries.each do |library|
        library.execute_phase!(phase, self)
      end
    end
  end
end
