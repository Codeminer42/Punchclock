FactoryBot.define do
  factory :punch do
    sequence(:from) { |i| DateTime.new(2001, 1, 5, 8, 0, 0, 0) }
    sequence(:to)   { |i| DateTime.new(2001, 1, 5, 17, 0, 0, 0) }
    user
    project { create(:project, company: user.company) }
    company { user.company }

    trait :is_extra_hour do
      extra_hour { true }
    end
    trait :with_attachment do
      attachment {Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/attachment.txt"))}
    end
  end
end
