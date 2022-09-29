# frozen_string_literal: true
def create_punches(project:, user:)
  (6.months.ago.to_date..1.day.ago.to_date).reject{ |d| d.saturday? || d.sunday? }.each do |date|
    date = date.to_time
    [[8, 12], [13, 16]].each do |hours|
      user.punches.create!(
        from: date.change(hour: hours.first),
        to: date.change(hour: hours.last),
        project: project
      )
    end
  end if user.punches.empty?
end

def create_holiday(office:)
  random_date = rand(Date.civil(2017, 1, 1)..Date.civil(2017, 12, 31))
  holiday = RegionalHoliday.find_or_create_by!(day: random_date.day, month: random_date.month) do |holiday|
    holiday.name = "#{Faker::Name.name} day"
  end
  holiday.offices << office
end

def create_user(number:)
  city = City.find_by!(name: 'São Paulo')
  user = User.find_or_create_by!(email: "user.teste#{number}@codeminer42.com") do |user|
    user.name = "Usuario_Codeminer42_#{number}"
    user.email = "user.teste#{number}@codeminer42.com"
    user.occupation = :engineer
    user.password = 'password'
    user.office = Office.all.sample
    user.level = User.level.values.sample
    user.specialty = User.specialty.values.sample
    user.github = "codeminer42.user.teste#{number}"
    user.allow_overtime = true
    user.city_id = city.id
    user.skip_confirmation!
    user.roles = [:normal]
    user.contract_company_country = 'brazil'
  end
end

def create_user_contribution(user:, repository:, date:)
  link = "#{repository.link}/pull/#{Faker::Number.digit}"

  ActiveRecord::Base.transaction do
    Contribution.find_or_create_by!(link: link) do |contrib|
      contrib.link = link
      contrib.user_id = user.id
      contrib.repository = repository
      contrib.created_at = date
      contrib.approve(user.id)
      contrib.save!
    end
  end
end

def create_contributions(users:, repositories:, dates:)
  print "Creating users contributions..."

  8.times do |i|
    user = users.sample

    dates.each do |contribution_date|
      rand(5).times do
        create_user_contribution(
          user: user,
          repository: repositories.sample,
          date: contribution_date
        )
      end
    end
  end

  puts "Done."
end

def create_repository(link:)
  Repository.create! link: link
end

codeminer42 = {
  name: 'Codeminer42',
  office_cities: [
    ['State Name', 'ST', 'Anápolis'],
    ['State Name', 'ST', 'Batatais'],
    ['State Name', 'ST', 'Campinas'],
    ['State Name', 'ST', 'Goiânia'],
    ['State Name', 'ST', 'Guarapuava'],
    ['State Name', 'ST', 'Natal'],
    ['State Name', 'ST', 'Novo Hamburgo'],
    ['State Name', 'ST', 'Santa Maria'],
    ['State Name', 'ST', 'Sorocaba'],
    ['State Name', 'ST', 'São Paulo'],
    ['State Name', 'ST', 'Teresina'],
    ['State Name', 'ST', 'Poços de Caldas'],
    ['State Name', 'ST', 'Belo Horizonte'],
    ['State Name', 'ST', 'Santa Catarina']
  ],
  project_names: [
    'Punchclock',
    'Rito Gomes',
    'Central',
    'Omnitrade'
  ]
}

repositories = [
  'http://github.com/flutter/flutter',
  'http://github.com/facebook/create-react-app',
  'http://github.com/ant-design/ant-design',
  'http://github.com/trekhleb/javascript-algorithms',
  'http://github.com/mui-org/material-ui',
  'http://github.com/rails/rails',
  'https://github.com/rubyforgood/diaper/',
  'https://github.com/ruby/ruby',
  'https://github.com/ReactiveX/rxdart',
  'https://github.com/jquense/yup',
  'https://github.com/buefy/buefy',
  'https://github.com/ruby-i18n/i18n'
]

print "..creating offices..."
offices = codeminer42[:office_cities]
offices.map do |city|
  Office.find_or_create_by!(city: city[2])
  City.create!(
    name: city[2], 
    state: State.find_or_create_by!(name: city[0], code: city[1])
  )
end
puts " done."

print "..creating projects..."
projects = codeminer42[:project_names]
projects.map do |project|
  Project.find_or_create_by!(name: project, market: Project.market.values.sample)
end
puts " done."

print "..creating Admins..."
User.find_or_create_by!(email: "admin@codeminer42.com") do |admin|
  admin.name = 'admin'
  admin.occupation = :administrative
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.roles = [:admin]
  admin.office = Office.all.sample
  admin.token = SecureRandom.base58(32)
  admin.skip_confirmation!
  admin.contract_company_country = 'brazil'
  admin.city = City.find_by!(name: 'São Paulo')
end
puts " done."

print "..creating offices holidays..."
rand(offices.size * 10).times do |i|
  create_holiday(office: Office.all.sample)
end
puts " done."

print "....creating dev punches..."
(projects.size * 10).times do |i|
  user = create_user(number: i)

  create_punches(
    project: Project.all.sample,
    user: user
  )
end
puts " done."

print "Creating codeminer42 open source repositories..."
repos = repositories.collect do |repository|
  create_repository(link: repository)
end
puts " done."

contributions_dates = 12.times.map do |i|
  i.months.ago.to_date
end

contributions = create_contributions(
  users: User.all,
  repositories: repos,
  dates: contributions_dates
)

print 'Creating mentors to some users..'

30.times do
  mentor = User.all.sample
  User.all.sample.update(reviewer_id: mentor.id)
end

puts 'Done.'
