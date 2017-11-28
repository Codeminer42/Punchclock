def create_punches(company:, project:, user:)
  (6.months.ago.to_date..1.day.ago.to_date).reject{ |d| d.saturday? || d.sunday? }.each do |date|
    date = date.to_time
    [[8, 12], [13, 16]].each do |hours|
      user.punches.create(
        from: date.change(hour: hours.first),
        to: date.change(hour: hours.last),
        company: company,
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

def create_company(name:, office_cities:, project_names:)
  ActiveRecord::Base.transaction do
    company = Company.find_or_create_by!(name: name)
    offices = office_cities.map do |city|
      Office.find_or_create_by!(city: city, company: company)
    end
    projects = project_names.map do |project|
      Project.find_or_create_by!(name: project, company: company)
    end

    AdminUser.find_or_create_by!(email: "super@#{name}.com") do |admin|
      admin.password = 'password'
      admin.password_confirmation = 'password'
      admin.is_super = true
      admin.company = company
    end

    AdminUser.find_or_create_by!(email: "admin@#{name}.com") do |admin|
      admin.password = 'password'
      admin.password_confirmation = 'password'
      admin.company = company
    end

    rand(offices.size * 10).times do |i|
      create_holiday(office: offices.sample)
    end

    users = (projects.size * 10).map do |i|
      user = User.find_or_create_by!(email: "user.teste#{i}@#{name}.com") do |user|
        user.name = "Usuario_#{name}_#{i}"
        user.email = "user.teste#{i}@#{name}.com"
        user.password = 'password'
        user.company = company
        user.office = offices.send(:[], i % offices.size)
        user.skip_confirmation!
      end

      create_punches(
        company: company,
        project: projects.send(:[], i % offices.size),
        user: user
      )
      user
    end
  end
end

create_company(name: 'Codeminer42', office_cities: ['Natal', 'Brasilia', 'São Paulo'], project_names: ['Punchclock', 'Rito Gomes', 'Central'])
create_company(name: 'WatersCo', office_cities: ['North Valerie', 'Lilachester'], project_names: ['Tres Zap', 'Latlux'])
