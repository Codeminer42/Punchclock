company = Company.where(name: 'Codeminer42').
  first_or_create! name: 'Codeminer42'

super_admin = AdminUser.where(email: 'super@codeminer42.com').
  first_or_create!(
    email: 'super@codeminer42.com',
    password: 'password',
    password_confirmation: 'password',
    is_super: true,
    company: company
  )

admin_user = AdminUser.where(email: 'admin@codeminer42.com').
  first_or_create!(
    email: 'admin@codeminer42.com',
    password: 'password',
    password_confirmation: 'password',
    company: company
  )

user = User.where(email: 'halan.pinheiro@codeminer42.com').
  first_or_create!(
    name: 'Halan Pinheiro',
    email: 'halan.pinheiro@codeminer42.com',
    password: 'password',
    company: company
  )

project = Project.where(name: 'Punchclock').first_or_create! company: company

(6.months.ago.to_date..1.day.ago.to_date).to_a.each do |date|
  date = date.to_time
  [[8, 12], [13, 16]].each do |hours|
    user.punches.create!(
      from: date.change(hour: hours.first),
      to: date.change(hour: hours.last),
      company: company,
      project: project
    )
  end
end if user.punches.empty?

