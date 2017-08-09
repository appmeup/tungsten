require 'sshkit'
require 'sshkit/dsl'

module Tungsten
  class Library
    include SSHKit::DSL

    PHASES = %w(install setup run restart shutdown uninstall error check)

    def initialize(name)
      @name = name
      @phases = {}
    end

    def phase(phase_name, &block)
      if PHASES.include?(phase_name.to_s)
        @phases[phase_name] = block
      else
        puts "Phase #{phase_name} doesn't exist"
      end
    end

    def execute_phase!(phase_name, instance)
      if @phases[phase_name]
        phase_block = @phases[phase_name]
        on instance.address do
          instance_eval &phase_block
        end
      end
    end
  end
end
