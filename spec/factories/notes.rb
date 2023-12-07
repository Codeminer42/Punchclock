FactoryBot.define do
  factory :note do
    comment { "MyString" }
    rate { "good" }
    title { "Title" }
    user { build(:user) }
    author { build(:user) }
  end
end
