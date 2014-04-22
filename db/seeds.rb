unless Company.exists?(name: 'Codeminer42')
  puts 'Creating default company'
  Company.create name: 'Codeminer42'
end

unless AdminUser.exists?(email: 'super@codeminer42.com')
  puts 'Creating default super user'
  AdminUser.create(
    email:                 'super@codeminer42.com',
    password:              'password',
    password_confirmation: 'password',
    is_super:              true,
    company_id:            Company.find_by_name('Codeminer42').id
  )
end

unless AdminUser.exists?(email: 'admin@codeminer42.com')
  puts 'Creating default admin user'
  AdminUser.create(
    email:                 'admin@codeminer42.com',
    password:              'password',
    password_confirmation: 'password',
    company_id:            Company.find_by_name('Codeminer42').id
  )
end

unless User.exists?(email: 'halan.pinheiro@codeminer42.com')
  puts 'Creating default user'
  User.create(
    name:                  'Halan Pinheiro',
    email:                 'halan.pinheiro@codeminer42.com',
    password:              'password',
    company_id:            Company.find_by_name('Codeminer42').id
  )
end
