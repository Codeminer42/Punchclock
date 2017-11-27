class User < ActiveRecord::Base
  belongs_to :office
  belongs_to :company
  belongs_to :reviewer, class_name: :User, foreign_key: :reviewer_id
  has_many :punches

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :company, presence: true

  accepts_nested_attributes_for :company

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  delegate :regional_holidays, to: :office, allow_nil: true

  enum role: %i(trainee junior pleno senior)

  def import_punches(input_file)
    transaction do
      CSV.foreach(input_file) { |line| import_punch * line }
    end
  end

  private

  def import_punch(from, to, project_name)
    project = Project.find_by name: project_name
    punches.create! from: from, to: to, project: project, company: company
  end
end
