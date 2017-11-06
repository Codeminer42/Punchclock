company = Company.find_or_create_by!(name: 'Codeminer42')
office  = Office.find_or_create_by!(city: 'Natal', company: company)
project = Project.find_or_create_by!(name: 'Punchclock', company: company)

AdminUser.find_or_create_by!(email: 'super@codeminer42.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.is_super = true
  admin.company = company
end

AdminUser.find_or_create_by!(email: 'admin@codeminer42.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.company = company
end

user_1 = User.find_or_create_by!(email: 'user.teste@codeminer42.com') do |user|
  user.name = 'Usuario'
  user.email = 'user.testeo@codeminer42.com'
  user.password = 'password'
  user.company = company
  user.office = office
end

(6.months.ago.to_date..1.day.ago.to_date).reject{ |d| d.saturday? || d.sunday? }.each do |date|
  date = date.to_time
  [[8, 12], [13, 16]].each do |hours|
    user_1.punches.create(
      from: date.change(hour: hours.first),
      to: date.change(hour: hours.last),
      company: company,
      project: project
    )
  end
end if user_1.punches.empty?
