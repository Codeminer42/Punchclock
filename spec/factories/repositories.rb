FactoryBot.define do
  factory :repository do
    company
    sequence :link do |n| 
      "https://github.com/Codeminer42/project-#{n}"
    end
    language { Faker::ProgrammingLanguage.name }
  end
end
