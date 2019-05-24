# frozen_string_literal: true

namespace :utils do
  desc "Updates all offices scores"
  task update_offices_scores: :environment do
    Office.find_each do |office|
      office.calculate_score
    end
  end
end
