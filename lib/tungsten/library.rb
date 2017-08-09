require 'tungsten/variable'
require 'sshkit'
require 'sshkit/dsl'

module Tungsten
  class Library
    include SSHKit::DSL

    PHASES = %w(install setup run restart shutdown uninstall error check)

    def initialize(name, args = {})
      @name = name
      @phases = {}
      @args = args
      @variables = {}
    end

    def set_args(args)
      @args = args
    end

    def merge_args(args)
      @args = @args.merge(args)
    end

    def execute_phase!(phase_name, instance)
      if @phases[phase_name]
        phase_block = @phases[phase_name]
        default_variables = variables_to_h
        variables = default_variables.merge(@args)
        library = self
        defaults = default_variables

        puts "#{@name}/#{phase_name}"

        on instance.address do
          @variables = variables
          @library = library
          @defaults = defaults

          def variables
            @variables
          end

          def library
            @library
          end

          def defaults
            @defaults
          end

          instance_eval(&phase_block)
        end
      else
        puts "#{@name}/#{phase_name} not configured"
      end
    end

    def variables_to_h
      variables = {}
      @variables.keys.each do |key|
        variables[key] = @variables[key].value
      end
      variables
    end

    def method_missing(name, *args, &block)
      if @variables[name]
        return @variables[name].value
      end

      raise "No method #{name} found"
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

    def add_variable(key, default_value = nil, description = 'No description')
      if !@variables.keys.include?(key)
        @variables[key] = Variable.new(key, default_value, description)
      else
        puts "Variable #{key} already defined!"
      end
    end
  end
end
