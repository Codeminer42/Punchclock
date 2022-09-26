# frozen_string_literal: true

FactoryBot.define do
  factory :allocation do
    user
    project
    hourly_rate { Money.new(rand(10000..35000)) }
    start_at { Date.today - rand(0..180) }
    end_at   { Date.today + rand(30..180) }
    ongoing { false }
  end
end
