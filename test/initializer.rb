puts "Im the initializer :)"
server '192.168.0.1', custom: 'something'

puts "Servers are: #{servers.inspect}"
