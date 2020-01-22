class Repository < ApplicationRecord
    belongs_to :company

    validates :link, presence: true, uniqueness: { scope: :company_id, case_sensitive: false }
end
