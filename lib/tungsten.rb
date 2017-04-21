require "tungsten/version"
require "tungsten/dsl"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.rb',
  }

  class << self
    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end

    def load!
      include Tungsten::DSL
      load options[:config_file]
    end
  end
end
