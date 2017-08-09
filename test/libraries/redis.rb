library :redis do
  phase :install do
    as :root do
      execute(:rm, '/etc/apt/sources.list.d/dotdeb.org.list')
      execute(:touch, '/etc/apt/sources.list.d/dotdeb.org.list')
      execute(:echo, '"deb http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list.d/dotdeb.org.list')
      execute(:echo, '"deb-src http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list.d/dotdeb.org.list')
      execute(:wget, '-q -O - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -')
    end
    execute('sudo apt-get update')
    execute('sudo apt-get install -y redis-server')
  end

  phase :setup do
    config_directory = args[:config_directory] || 'redis'
    config_file = config_directory+'/'+(args[:conf_file] || 'redis.conf')

    as :root do
      execute(:mkdir, "-p #{config_directory}") rescue nil
      execute(:touch, config_file)
      execute("echo 'daemonize yes' | sudo tee -a #{config_file}")
    end
  end

  phase :run do
    config_directory = args[:config_directory] || 'redis'
    config_file = config_directory+'/'+(args[:conf_file] || 'redis.conf')

    as :root do
      execute('redis-server '+config_file) rescue puts("Redis run command failed")
    end
  end
end
