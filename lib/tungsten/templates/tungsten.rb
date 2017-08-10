# Use installed external libraries
# require 'tungsten/redis'

# Add your servers and assign them roles
server '99.99.99.99', roles: [:app, :db], user: 'ubuntu', key: '~/path/to/key.cer'

# Define which libraries your roles will use
role :app do
  uses :redis
end

role :db do
  uses :customized, {port: '9876'}
end

# Define libraries on the fly
library :customized do
  default :port, 1234, 'Some default and customizable argument'

  phase :install do
    # Define your commands when installing this library with SSHKit
    execute('echo "INSERT YOUR COMMAND HERE"')
  end

  phase :setup do
    # Define your commands when setting this library with SSHKit
  end

  phase :start do
    # Define your commands when starting this library with SSHKit
  end

  phase :check do
    # Define your commands when checking this library with SSHKit
  end

  phase :stop do
    # Define your commands when stopping this library with SSHKit
  end

  phase :uninstall do
    # Define your commands when uninstalling this library with SSHKit
  end
end
