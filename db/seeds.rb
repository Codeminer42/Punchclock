# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless AdminUser.exists?(email: 'admin@codeminer42.com')
  puts 'Creating default admin user'
  AdminUser.create(
    email:                 'admin@codeminer42.com',
    password:              'password',
    password_confirmation: 'password',
    is_super:              true
  )
end