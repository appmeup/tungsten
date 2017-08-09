library :redis do
  phase :install do |instance|
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

library :postgresql do
  phase :install do
    puts "PostgreSQL installed!"
  end
end

add_server '34.204.37.136', roles: [:app, :db], user: 'ubuntu', key: '../raaf-api/config/raaf-certificate.cer'

role :app do
  uses :redis
  uses :postgresql
end
