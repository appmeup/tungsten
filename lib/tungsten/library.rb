require 'tungsten/variable'
require 'sshkit'
require 'sshkit/dsl'

module Tungsten
  class Library
    include SSHKit::DSL

    PHASES = %w(install setup start stop check uninstall)

    def initialize(name, metadata = {})
      @name = name
      @phases = {}
      @args = {}
      @defaults = {}
      @metadata = metadata
    end

    def name
      @name
    end

    def phases
      @phases
    end

    def variables
      @defaults
    end

    def set_args(args)
      @args = args
    end

    def merge_args(args)
      @args = @args.merge(args)
    end

    def execute_phase!(phase_name, instance)
      if @phases[phase_name]
        if @metadata['lock'] && @metadata['lock'].gsub('.', '') < VERSION.gsub('.', '')
          puts "[WARN] #{@name} is locked on Tungsten #{@metadata['lock']} (Current Tungsten version is: #{VERSION})"
        end
        phase_block = @phases[phase_name]
        default_args = variables_to_h
        args = default_args.merge(@args)
        library = self
        defaults = default_args

        puts "#{@name}/#{phase_name}"

        on instance.address do
          @defaults = default_args
          @library = library
          @args = args

          def defaults
            @defaults
          end

          def library
            @library
          end

          def args
            @args
          end

          instance_eval(&phase_block)
        end
      else
        puts "#{@name}/#{phase_name} not configured"
      end
    end

    def variables_to_h
      variables = {}
      @defaults.keys.each do |key|
        variables[key] = @defaults[key].value
      end
      variables
    end

    def method_missing(name, *args, &block)
      if @defaults[name]
        return @defaults[name].value
      end

      raise "No method #{name} found"
    end

    def get_metadata
      @metadata
    end

    #####################
    # Library DSL
    #####################

    def phase(phase_name, &block)
      if PHASES.include?(phase_name.to_s)
        @phases[phase_name] = block
      else
        puts "Phase #{phase_name} doesn't exist"
      end
    end

    def default(key, default_value = nil, description = 'No description')
      if !@defaults.keys.include?(key)
        @defaults[key] = Variable.new(key, default_value, description)
      else
        puts "Variable #{key} already defined!"
      end
    end

    def metadata(key, value)
      @metadata[key] = value
    end

    def lock(version)
      @metadata[:lock] = version
    end
  end
end
