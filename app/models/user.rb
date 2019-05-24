# frozen_string_literal: true

class User < ApplicationRecord
  extend ActiveModel::Naming

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  enum role: %i(trainee junior junior_plus mid mid_plus senior senior_plus)
  enum occupation: %i(administrative engineer)
  enum specialty: %i(frontend backend devops fullstack)

  belongs_to :office, optional: true
  belongs_to :company
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id, optional: true
  has_many :punches
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :allocations, dependent: :restrict_with_error
  has_many :projects, through: :allocations
  has_many :evaluations, foreign_key: :evaluated_id, dependent: :restrict_with_error
  has_many :managed_offices, class_name: 'Office', foreign_key: :head_id

  validates :name, :occupation, presence: true
  validates :email, uniqueness: true, presence: true
  validates :role, presence: true, if: -> { occupation == 'engineer' }
  delegate :name, to: :office, prefix: true
  delegate :city, to: :office, prefix: true, allow_nil: true

  scope :active,         -> { where(active: true) }
  scope :inactive,       -> { where(active: false) }
  scope :office_heads,   -> { where(id: Office.select(:head_id)) }
  scope :not_allocated,  -> { where.not(id: Allocation.select(:user_id)) }
  scope :with_access,    -> { where.not(encrypted_password: '') }
  scope :without_access, -> { where(encrypted_password: '') }
  scope :admins,         -> { where(admin: true) }


  # FIXME: Remove n+1 query
  scope :by_skills_in, -> (*skill_ids) do
    users_with_all_skills = skill_ids.map { |id| User.joins(:skills).where('skills.id': id) }.reduce(:&)
    where(id: users_with_all_skills)
  end

  def self.ransackable_scopes(_auth_object)
    [:by_skills_in]
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

  def password_required?
    false
  end

  def to_s
    name
  end

  def last_evaluation
    evaluations.last || OpenStruct.new(score: nil)
  end

  def english_level
    evaluations.by_kind(:english).order('created_at').last.try(:english_level)
  end

  def performance_score
    evaluations.by_kind(:performance).average(:score).try(:round, 2)
  end

  def english_score
    evaluations.by_kind(:english).last.try(:score)
  end

  def overall_score
    return if [performance_score, english_score].include?(nil)
    return unless [performance_score, english_score].all? { |n| n.positive? }

    (performance_score.to_f + english_score.to_f) / 2.0
  end

  def current_allocation
    allocations.where("start_at <= :date", date: Date.today).order(end_at: :desc).first.try(:project)
  end

  def has_access?
    encrypted_password.present?
  end

  def office_head?
    managed_offices.present?
  end

  def remove_access
    update(encrypted_password: '')
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
