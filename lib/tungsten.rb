require "tungsten/version"
require "tungsten/dsl"
require 'yaml'

module Tungsten
  DEFAULT_OPTIONS = {
    config_file: 'config/tungsten.rb',
  }

  class << self
    include Tungsten::DSL

    def options
      @options ||= DEFAULT_OPTIONS.dup
    end

    def options= opts
      @options = opts
    end

    def load!
      eval(File.open(options[:config_file], 'r').read)
      run_dsl!
    end
  end
end
