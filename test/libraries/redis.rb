library :redis do
  add_variable :config_directory, 'redis', 'The root directory of Redis configuration'
  add_variable :config_file, config_directory+'/redis.conf', 'Redis main configuraiton file'

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
    as :root do
      execute(:mkdir, "-p #{variables[:config_directory]}") rescue nil
      execute(:touch, variables[:config_file])
      execute("echo 'daemonize yes' | sudo tee -a #{variables[:config_file]}")
    end
  end

  phase :run do
    as :root do
      execute("redis-server #{variables[:config_file]}") rescue puts("Redis run command failed")
    end
  end
end
