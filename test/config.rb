server '34.204.37.136', roles: %w(app), user: 'ubuntu', key: '~/Desktop/test.cer'

installation :web do |instance|
  on instance.address do

  end
end

installation :app do |instance|
  on instance.address do
    # Install Redis
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
end

execution :web do |instance|
  on instance.address do

  end
end

execution :app do |instance|
  on instance.address do

  end
end
