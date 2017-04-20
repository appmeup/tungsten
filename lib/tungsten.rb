require "tungsten/version"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.yml'
  }
  DEFAULT_CONFIG={

  }

  class << self
    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end

    def load_configuration!
      config_file = options[:config_file]
      if File.exists?(config_file)
        yaml = YAML.load_file(config_file)
        @configuration = {}
      else
        @configuration = DEFAULT_CONFIG
      end
    end

    def configuration
      @configuration ||= DEFAULT_CONFIG.dup
    end
  end
end
