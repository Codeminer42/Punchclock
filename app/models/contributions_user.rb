class ContributionsUser < ApplicationRecord
  belongs_to :contribution
  belongs_to :user
end
