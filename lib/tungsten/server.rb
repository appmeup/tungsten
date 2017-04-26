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
        user: options[:user],
        keys: [options[:key]].flatten
      }
    end

    def has_custom_ssh?
      options.has_key?(:user) || options.has_key?(:key)
    end
  end
end
