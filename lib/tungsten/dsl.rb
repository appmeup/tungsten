require 'tungsten/server'
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

module Tungsten
  module DSL
    attr_accessor :servers

    def server(address, options)
      @servers ||= []
      @servers << Server.new(address, options)
    end

    def roles(roles_array_or_role)
      servers = @servers.select do |server|
        valid_server = false
        if roles_array_or_role.is_a?(Array)
          roles_array_or_role.each do |role|
            if server.has_role?(role)
              valid_server = true
            end
          end
        else
          if server.has_role?(roles_array_or_role)
            valid_server = true
          end
        end
        valid_server
      end
      servers.map do |server|
        server.address
      end
    end

    def get_server(address)
      @servers.select do |server|
        server.address == address
      end.last
    end

    def commands(roles_array)
      roles_array = [roles_array] unless roles_array.is_a?(Array)
      # TODO: Create a DSL to allow user to prepare commands. These will be stored in Tungsten::DSL
      @some_var = 'something it!'
    end

    def run_dsl!
      # TODO: Commands for each role will be stored in variables that will be passed to SSHKit so that it executes them for each corresponding role
      some_var = @some_var
      on roles(:web) do |host|
        # TODO: Configure how SSH keys will be passed
        SSHKit::Backend::Netssh.configure do |ssh|
          ssh.ssh_options = {
            user: 'ubuntu',
            keys: ['../raaf-api/config/raaf-certificate.cer']
          }
        end
        within '~' do
          puts some_var
          execute "ls -la"
        end
      end
    end
  end
end
