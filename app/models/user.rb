# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize

  EXPERIENCE_PERIOD = 3.months

  devise :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :two_factor_authenticatable,
         :two_factor_backupable,
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  enumerize :level, in: {
    trainee: 7, intern: 0, junior: 1, junior_plus: 2, mid: 3, mid_plus: 4, senior: 5, senior_plus: 6
    },  scope: :shallow,
        predicates: true

  enumerize :occupation, in: {
    administrative: 0, engineer: 1
    },  scope: :shallow,
        predicates: true

  enumerize :specialty, in: {
    frontend: 0, backend: 1, devops: 2, mobile: 4, qa: 5
    },  scope: :shallow,
        predicates: true

  enumerize :contract_type, in: {
    internship: 0, employee: 1, contractor: 2, associate: 3
    },  scope: :shallow,
        predicates: true
  enumerize :contract_company_country, in: { brazil: 0, usa: 1 }

  enumerize :roles, in: {
    evaluator: 1,
    admin: 2,
    open_source_manager: 3
  }, multiple: true, predicates: true

  belongs_to :office, optional: false
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  belongs_to :city
  has_many :punches
  has_many :contributions
  has_many :allocations, dependent: :restrict_with_error
  has_many :projects, through: :allocations
  has_many :evaluations, foreign_key: :evaluated_id, dependent: :restrict_with_error
  has_many :managed_offices, class_name: 'Office', foreign_key: :head_id
  has_many :notes
  has_many :authored_notes, class_name: 'Note', inverse_of: :author
  has_and_belongs_to_many :skills

  validates :name, :occupation, presence: true
  validates :email, uniqueness: true, presence: true
  validates :level, :specialty, presence: true, if: :engineer?
  validates :github, uniqueness: true, if: :engineer?

  # delegate :city, to: :office, prefix: true, allow_nil: true

  scope :active,         -> { where(active: true) }
  scope :inactive,       -> { where(active: false) }
  scope :office_heads,   -> { where(id: Office.select(:head_id)) }
  scope :not_allocated,  -> { engineer.active.where.not(id: Allocation.ongoing.select(:user_id)) }
  scope :allocated, -> { engineer.active.where(id: Allocation.ongoing.select(:user_id)) }
  scope :by_skills_in,   ->(*skill_ids) { UsersBySkillsQuery.where(ids: skill_ids) }
  scope :not_in_experience, -> { where arel_table[:created_at].lt(EXPERIENCE_PERIOD.ago) }
  scope :with_level,       -> value { where(level: value) }
  scope :by_roles_in, lambda { |roles|
    roles_values = self.roles.find_values(*roles).map(&:value)
    where("users.roles && ARRAY[?]::int[]", roles_values)
  }
  scope :admin, -> { by_roles_in([:admin]) }

  attr_accessor :password_required

  def self.ransackable_scopes_skip_sanitize_args
    [:by_skills_in]
  end

  def self.ransackable_scopes(_auth_object)
    [:by_skills_in]
  end

  def self.overall_score_average
    overall_scores = all.map(&:overall_score).compact

    return 0 if overall_scores.empty?
    (overall_scores.sum / overall_scores.size).round(2)
  end

  def disable!
    update!(active: false)
  end

  def enable!
    update!(active: true)
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :inactive_account
  end

  def office_holidays
    HolidaysService.from_office(office)
  end

  def to_s
    first_and_last_name
  end

  def performance_score
    evaluations.by_kind(:performance).average(:score).try(:round, 2)
  end

  def english_level
    last_english_evaluation.try(:english_level)
  end

  def english_score
    last_english_evaluation.try(:score)
  end

  def last_english_evaluation
    evaluations.by_kind(:english).order(:created_at).last
  end

  def last_performance_evaluation
    evaluations.by_kind(:performance).order(:created_at).last
  end

  def overall_score
    return if [performance_score, english_score].include?(nil)

    (performance_score.to_f + english_score.to_f) / 2.0
  end

  def current_allocation
    allocations.ongoing.first.try(:project)
  end

  def office_head?
    managed_offices.present?
  end

  def update_with_password(params, *options)
    current_password      = params[:current_password]
    password              = params[:password]
    password_confirmation = params[:password_confirmation]

    if current_password.blank?
      super
    else
        errors.add(:password, "não pode ficar em branco") if password.blank?
        errors.add(:password_confirmation, "não pode ficar em branco") if password_confirmation.blank?
      if password_confirmation != password
        errors.add(:password_confirmation, "não é igual a Password")
      end
    end

    errors.present? ? false : super
  end

  def password_required?
    password_required
  end

  def first_and_last_name
    name.split.values_at(0, -1).uniq.join(' ')
  end
end
