class User < ActiveRecord::Base
  belongs_to :company
  devise :invitable, :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :invitable
  has_many :punches
  has_many :notifications
  validates :name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :company, presence: true

  accepts_nested_attributes_for :company

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.find_for_googleapps_oauth(access_token, signed_in_resource = nil)
    data = access_token['info']
    User.where(email: data['email']).first_or_create! name: data['name']
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      data = googleapps_user_info(session)
      user.email = data['email'] if data
    end
  end

  def import_punches(input_file)
    transaction do
      CSV.foreach(input_file) { |line| import_punch * line }
    end
  end

  private

  def googleapps_user_info(session)
    session.fetch('devise.googleapps_data', {}).fetch('user_info', nil)
  end

  def import_punch(from, to, project_name)
    project = Project.find_by name: project_name
    punches.create! from: from, to: to, project: project, company: company
  end
end
