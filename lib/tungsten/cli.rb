require 'tungsten'
require 'optparse'

module Tungsten
  class CLI
    def initialize

    end

    def parse
      parsed_options = parse_options(ARGV)
      Tungsten.options.merge!(parsed_options)
      # puts "With options: #{Tungsten.options.inspect}"
    end

    def run
      # Load Tungsten configuration
      Tungsten.load!

      # Check which action was executed
      case ARGV[0]
      when 'init'
        # Run installation, setup and run commands
        Tungsten.init!
      when 'install'
        # Run installation commands
        Tungsten.install!
      when 'setup'
        # Run setup commands
        Tungsten.setup!
      when 'start'
        # Run start commands
        Tungsten.start!
      when 'stop'
        # Run stop commands
        Tungsten.stop!
      when 'check'
        # Run check commands
        Tungsten.check!
      when 'restart'
        # Run stop and run commands
        Tungsten.restart!
      when 'uninstall'
        # Run stop and uninstall commands
        Tungsten.uninstall!
      when 'lib'
        # Run stop and uninstall commands
        Tungsten.display_lib_info!(ARGV[1])
      else
        puts "No action supported"
      end
    end

    def parse_options(argsv)
      opts = {}
      @parser = OptionParser.new do |opt|
        opt.banner = "Usage: tungsten [options]"

        opt.on '-C', '--config PATH', 'path to config file' do |arg|
          opts[:config_file] = arg
        end

        opt.on '-L', '--libraries PATH', 'path to libraries directory' do |arg|
          opts[:libraries_directory] = arg
        end
      end
      @parser.parse!(argsv)

      opts
    end
  end
end
