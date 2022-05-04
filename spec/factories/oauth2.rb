FactoryBot.define do
  factory :oauth2_access_token, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { :resource_owner_id }
    application_id { :application_id }

    trait :expired do
      expires_in { 0 }
    end
  end

  factory :oauth2_app, class: 'Doorkeeper::Application' do
    sequence(:name) { |n| "Application #{n}" }
    redirect_uri { 'https://test.com/callback' }
    confidential { false }
  end
end
