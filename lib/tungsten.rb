require "tungsten/version"
require "tungsten/dsl"
require "tungsten/core"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.rb',
    libraries_directory: 'config/tungsten'
  }

  class << self
    include Tungsten::DSL
    include Tungsten::Core

    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end
  end
end
