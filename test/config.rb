require 'tungsten/redis'

server '34.204.37.136', roles: [:app], user: 'ubuntu', key: '~/Desktop/test.cer'

role :app do
  uses :redis
end
