# frozen_string_literal: true

class User < ApplicationRecord
  EXPERIENCE_PERIOD = 3.months

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  enum level: %i[trainee junior junior_plus mid mid_plus senior senior_plus]
  enum occupation: %i[administrative engineer]
  enum specialty: %i[frontend backend devops fullstack mobile]
  enum contract_type: %i[internship employee contractor]
  enum role: %i[normal evaluator admin super_admin]

  belongs_to :office, optional: true
  belongs_to :company
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  has_many :punches
  has_many :allocations, dependent: :restrict_with_error
  has_many :projects, through: :allocations
  has_many :evaluations, foreign_key: :evaluated_id, dependent: :restrict_with_error
  has_many :managed_offices, class_name: 'Office', foreign_key: :head_id
  has_and_belongs_to_many :skills

  validates :name, :occupation, presence: true
  validates :email, uniqueness: true, presence: true
  validates :level, presence: true, if: :engineer?

  delegate :city, to: :office, prefix: true, allow_nil: true

  scope :active,         -> { where(active: true) }
  scope :inactive,       -> { where(active: false) }
  scope :office_heads,   -> { where(id: Office.select(:head_id)) }
  scope :not_allocated,  -> { engineer.active.where.not(id: Allocation.ongoing.select(:user_id)) }
  scope :by_skills_in,   ->(*skill_ids) { UsersBySkillsQuery.where(ids: skill_ids) }
  scope :not_in_experience, -> { where arel_table[:created_at].lt(EXPERIENCE_PERIOD.ago) }
  scope :with_level,       -> value { where(level: value) }

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
    name
  end

  def last_evaluation
    evaluations.last || OpenStruct.new(score: nil)
  end

  def english_level
    evaluations.by_kind(:english).order(:created_at).last.try(:english_level)
  end

  def performance_score
    evaluations.by_kind(:performance).average(:score).try(:round, 2)
  end

  def english_score
    evaluations.by_kind(:english).last.try(:score)
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

  def has_admin_access?
    admin? || super_admin?
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
end
