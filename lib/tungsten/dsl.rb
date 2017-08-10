module Tungsten
  module DSL
    def server(address, options)
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
