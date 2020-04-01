# frozen_string_literal: true
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
    holiday.company = office.company
    holiday.name = "#{Faker::Name.name} day"
  end
  holiday.offices << office
end

def create_company(name:, office_cities:, project_names:, clients_name:)
  ActiveRecord::Base.transaction do
    company = Company.find_or_create_by!(name: name)
    offices = office_cities.map do |city|
      Office.find_or_create_by!(city: city, company: company)
    end
    clients = clients_name.map do |client|
      Client.create_with(company: company).find_or_create_by!(name: client)
    end
    projects = project_names.map do |project|
      Project.find_or_create_by!(name: project, company: company)
    end

    User.find_or_create_by!(email: "super@#{name}.com") do |admin|
      admin.name = 'super'
      admin.occupation = :administrative
      admin.password = 'password'
      admin.password_confirmation = 'password'
      admin.role = :super_admin
      admin.company = company
      admin.token = SecureRandom.base58(32)
      admin.skip_confirmation!
    end

    User.find_or_create_by!(email: "admin@#{name}.com") do |admin|
      admin.name = 'admin'
      admin.occupation = :administrative
      admin.password = 'password'
      admin.password_confirmation = 'password'
      admin.role = :admin
      admin.company = company
      admin.token = SecureRandom.base58(32)
      admin.token = '9X9ti7nAeN3J2w9hn1om9ztpPMHrT7Mj' if name == 'Codeminer42'
      admin.skip_confirmation!
    end

    rand(offices.size * 10).times do |i|
      create_holiday(office: offices.sample)
    end

    (projects.size * 10).times do |i|
      user = User.find_or_create_by!(email: "user.teste#{i}@#{name}.com") do |user|
        user.name = "Usuario_#{name}_#{i}"
        user.email = "user.teste#{i}@#{name}.com"
        user.occupation = :engineer
        user.password = 'password'
        user.company = company
        user.office = offices.sample
        user.level = User.level.values.sample
        user.specialty = User.specialty.values.sample
        user.github = "#{name}.user.teste#{i}"
        user.skip_confirmation!
      end

      create_punches(
        company: company,
        project: projects[i % offices.size],
        user: user
      )
    end
  end
  Company.find_by(name: name)
end

codeminer42 = create_company(
  name: 'Codeminer42',
  office_cities: [
    'Anápolis',
    'Batatais',
    'Campinas',
    'Goiânia',
    'Guarapuava',
    'Natal',
    'Novo Hamburgo',
    'Santa Maria',
    'Sorocaba',
    'São Paulo',
    'Teresina',
    'Poços de Caldas',
    'Belo Horizonte',
    'Santa Catarina'
  ],
  project_names: [
    'Punchclock',
    'Rito Gomes',
    'Central',
    'Omnitrade'
  ],
  clients_name: [
    'Client3',
    'Client4',
    'Zaca'
  ]
)

waters_co = create_company(
  name: 'WatersCo',
  office_cities: [
    'North Valerie',
    'Lilachester'
  ],
  project_names: [
    'Tres Zap',
    'Latlux'
  ],
  clients_name: [
    'Client1',
    'Client2'
  ]
)

repositories = [
  'http://github.com/flutter/flutter',
  'http://github.com/facebook/create-react-app',
  'http://github.com/ant-design/ant-design',
  'http://github.com/trekhleb/javascript-algorithms',
  'http://github.com/mui-org/material-ui',
  'http://github.com/rails/rails',
  'http://github.com/gatsbyjs/gatsby',
  'http://github.com/impress/impress.js',
  'http://github.com/jgthms/bulma',
  'http://github.com/robbyrussell/oh-my-zsh',
  'http://github.com/facebook/jest',
  'http://github.com/iamkun/dayjs',
  'http://github.com/plataformatec/devise',
  'http://github.com/sequelize/sequelize',
  'http://github.com/Marak/faker.js',
  'http://github.com/tootsuite/mastodon',
  'http://github.com/helm/charts',
  'http://github.com/facebook/flow',
  'http://github.com/jaredpalmer/formik',
  'http://github.com/date-fns/date-fns',
  'http://github.com/elixir-lang/elixir',
  'http://github.com/BoostIO/Boostnote',
  'http://github.com/tailwindcss/tailwindcss',
  'http://github.com/tastejs/todomvc',
  'http://github.com/diaspora/diaspora',
  'http://github.com/thepracticaldev/dev.to',
  'http://github.com/rubocop-hq/rubocop',
  'http://github.com/activeadmin/activeadmin',
  'http://github.com/sinatra/sinatra',
  'http://github.com/stympy/faker',
  'http://github.com/faker-ruby/faker',
  'http://github.com/denysdovhan/spaceship-prompt',
  'http://github.com/sherlock-project/sherlock',
  'http://github.com/akiran/react-slick',
  'http://github.com/expo/expo',
  'http://github.com/segmentio/evergreen',
  'http://github.com/moment/luxon',
  'http://github.com/jquense/yup',
  'http://github.com/reactjs/reactjs.org',
  'http://github.com/vuejs/vuejs.org',
  'http://github.com/Solido/awesome-flutter',
  'http://github.com/plouc/nivo',
  'http://github.com/svenfuchs/rails-i18n',
  'http://github.com/pry/pry',
  'http://github.com/grommet/grommet',
  'http://github.com/rails/webpacker',
  'http://github.com/react-navigation/react-navigation',
  'http://github.com/callstack/react-native-paper',
  'http://github.com/drapergem/draper',
  'http://github.com/thoughtbot/administrate',
  'http://github.com/vcr/vcr',
  'http://github.com/fatfreecrm/fat_free_crm',
  'http://github.com/ctrlpvim/ctrlp.vim',
  'http://github.com/lancedikson/bowser',
  'http://github.com/JeffreyWay/laravel-mix',
  'http://github.com/awesome-print/awesome_print',
  'http://github.com/mikel/mail',
  'http://github.com/xotahal/react-native-material-ui',
  'http://github.com/travisjeffery/timecop',
  'http://github.com/thoughtbot/shoulda-matchers',
  'http://github.com/react-native-community/react-native-blur',
  'http://github.com/Rocketseat/unform',
  'http://github.com/rubykube/peatio',
  'http://github.com/lobsters/lobsters',
  'http://github.com/teamcapybara/capybara',
  'http://github.com/omarroth/invidious',
  'http://github.com/igorescobar/jQuery-Mask-Plugin',
  'http://github.com/rubygems/rubygems.org',
  'http://github.com/welldone-software/why-did-you-render',
  'http://github.com/cucumber/cucumber-ruby',
  'http://github.com/ffaker/ffaker',
  'http://github.com/chrismccord/render_sync',
  'http://github.com/infinitered/gluegun',
  'http://github.com/education/classroom',
  'http://github.com/twilio/twilio-ruby',
  'http://github.com/gocardless/statesman',
  'http://github.com/sporkmonger/addressable',
  'http://github.com/idyll-lang/idyll',
  'http://github.com/plentz/lol_dba',
  'http://github.com/codetriage/codetriage',
  'http://github.com/mozilla-mobile/android-components',
  'http://github.com/withspectrum/spectrum',
  'http://github.com/mojombo/chronic',
  'http://github.com/kotlintest/kotlintest',
  'http://github.com/rspec/rspec-core',
  'http://github.com/consul/consul',
  'http://github.com/ifmeorg/ifme',
  'http://github.com/publiclab/plots2',
  'http://github.com/rails-sqlserver/activerecord-sqlserver-adapter',
  'http://github.com/SimpleMobileTools/Simple-Gallery',
  'http://github.com/react-native-community/cli',
  'http://github.com/mozilla/multi-account-containers',
  'http://github.com/openSUSE/osem',
  'https://github.com/rubyforgood/diaper/',
  'https://github.com/rubyforgood/voices-of-consent/',
  'https://github.com/openfoodfoundation/openfoodnetwork',
  'https://github.com/City-Bureau/city-scrapers',
  'https://github.com/vuetifyjs/vuetify/',
  'https://github.com/best-flutter/flutter_swiper',
  'https://github.com/hasura/graphql-engine',
  'https://github.com/mperham/sidekiq',
  'https://github.com/nsarno/knock',
  'https://github.com/ruby/ruby',
  'https://github.com/ReactiveX/rxdart',
  'https://github.com/jquense/yup',
  'https://github.com/buefy/buefy',
  'https://github.com/ruby-i18n/i18n'
]

repositories.each do |repository|
  Repository.create! link: repository, company: codeminer42
  Repository.create! link: repository, company: waters_co
end
