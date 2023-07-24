FactoryBot.define do
  factory :repository do
    sequence :link do |n|
      "https://github.com/Codeminer42/project-#{Faker::Number.number(digits: 2)}#{n}"
    end
    language { Faker::ProgrammingLanguage.name }
    description { Faker::Movies::HarryPotter.quote }
  end
end
