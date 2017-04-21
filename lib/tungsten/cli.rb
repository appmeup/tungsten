require 'tungsten'
require 'optparse'

module Tungsten
  class CLI
    def initialize

    end

    def parse
      Tungsten.options.merge!(parse_options(ARGV))
      puts "With options: #{Tungsten.options.inspect}"
    end

    def run
      initial_time = Time.new
      puts "[#{initial_time.to_s}] Starting tungsten..."
      Tungsten.load!
      puts "[#{initial_time.to_s}] Done"
    end

    def parse_options(argsv)
      opts = {}

      @parser = OptionParser.new do |opt|
        opt.banner = "Usage: tungsten [options]"

        opt.on '-C', '--config PATH', 'path to config file' do |arg|
          opts[:config_file] = arg if File.exist?(arg)
        end
      end
      @parser.parse!(argsv)

      opts
    end
  end
end
