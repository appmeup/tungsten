require 'tungsten/server'

module Tungsten
  module DSL
    attr_accessor :servers

    def add_server(address, options)
      Tungsten.register_server(address, options)
    end

    def library(name, &block)
      Tungsten.register_library(name).instance_eval(&block)
    end

    def role(role_name, &block)
      Tungsten.register_role(role_name).instance_eval(&block)
    end
  end
end
