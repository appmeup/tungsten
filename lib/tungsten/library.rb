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
    end

    def set_args(args)
      @args = args
    end

    def merge_args(args)
      @args = @args.merge(args)
    end

    def execute_phase!(phase_name, instance)
      if @phases[phase_name]
        tungsten_args = @args.dup
        phase_block = @phases[phase_name]
        library = self

        puts "#{@name}/#{phase_name}"

        on instance.address do
          @tungsten_args = tungsten_args

          def args
            @tungsten_args
          end

          instance_eval(&phase_block)
        end
      else
        puts "#{@name}/#{phase_name} not configured"
      end
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
  end
end
