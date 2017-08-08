server '34.207.110.241', roles: %w(app), user: 'ubuntu', key: '~/Desktop/raaf-certificate.cer'

installation :web do |instance|
  on instance.address do

  end
end

installation :app do |instance|
  on instance.address do
    
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
