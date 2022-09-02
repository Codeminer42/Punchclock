FactoryBot.define do
  factory :city do
    name { "MyString" }
    state { create(:state) }
  end
end
