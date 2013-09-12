# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Company.exists?(name: 'Codeminer42')
  puts 'Creating default company'
  company = Company.create name: 'Codeminer42'
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

unless User.exists?(email: 'fernando.martinez@codeminer42.com')
  puts 'Creating default user'
  AdminUser.create(
    name:                  'Fernando Martínez',
    email:                 'fernando.martinez@codeminer42.com',
    password:              'password',
    company_id:            Company.find_by_name('Codeminer42').id
  )
end