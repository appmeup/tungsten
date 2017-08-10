# Tungsten

SSH commands to remote servers like a boss

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tungsten'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tungsten

## Quick Start

Get started by executing:

    $ bundle exec tungsten init

This will create a file: `config/tungsten.rb`

## Usage

Add servers to your script in `config/tungsten.rb` like:

```ruby
server '99.99.99.99', roles: [:app, :db], user: 'ubuntu', key: '~/path/to/key.cer'
```

Configure your roles:

```ruby
role :app do
  uses :redis
end
```

Configure libraries on the fly:

```ruby
library :redis do
  default :port, 6379, 'Some default and customizable argument'
  default :config_file, '/etc/my_config.conf', 'Some default and customizable argument'

  phase :install do
    # Define your commands when installing this library with SSHKit
    execute('sudo apt-get install -y SOME_LIBRARY')
  end

  phase :setup do
    # Define your commands when setting this library with SSHKit
    execute("echo 'port #{args[:port]}' | sudo tee -a #{args[:config_file]}")
  end

  phase :start do
    # Define your commands when starting this library with SSHKit
    execute('SOME_LIBRARY start')
  end

  phase :stop do
    # Define your commands when stopping this library with SSHKit
    execute('SOME_LIBRARY stop')
    execute('sudo apt-get remove -y SOME_LIBRARY')
  end
end
```



Or use external libraries adding this at the beginning of your `config/tungsten.rb`:

```ruby
require 'tungsten/<EXTERNAL_LIBRARY>'
```

## Executing Commands

Normally you will trigger commands like:

    $ tungsten [command]

### Available Commands

- `tungsten up`: Issues installation, setup and running of all libraries to all servers
- `tungsten servers`: Display all configured servers
- `tungsten libs`: Display all available libraries
- `tungsten lib [library_name]`: Get info about an specific library
- `tungsten roles`: Display all configured roles
- `tungsten role [role_name]`: Get info about an specific role
- `tungsten install`: Issues an installation to all servers
- `tungsten setup`: Issues a setup of all libraries to all servers
- `tungsten start`: Issues all servers to start all libraries
- `tungsten stop`: Issues all servers to stop all libraries
- `tungsten check`: Issues all servers to check all libraries
- `tungsten restart`: Issues all servers to restart all libraries
- `tungsten uninstall`: Issues all servers to uninstall all libraries

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Test gem locally

You can use the following command:

    $ rake install && tungsten [command] -C test/config.rb -L test/libraries

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tungsten. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
