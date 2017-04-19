require 'yaml'
require 'optparse'

module Tungsten
  class CLI
    def initialize

    end

    def parse
      puts "Parsing options"
    end

    def run
      puts "Running tungsten!"
    end

    def parse_options(argsv)
      opts = {}

      @parser = OptionParser.new do |opt|
        opt.banner = "Usage: tungsten [options]"

        opt.on '-C', '--config PATH', 'path to config file (YAML)' do |arg|
          opts[:config_file] = arg if File.exist?(arg)
        end
      end

      opts[:config_file] ||= 'config/tungsten.yml' if File.exist?('config/tungsten.yml')

      @parser.parse!(argsv)

      opts
    end
  end
end
