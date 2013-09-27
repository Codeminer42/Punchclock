class User < ActiveRecord::Base
  belongs_to :company
  devise :invitable, :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :registerable, :invitable
  has_many :punches
  validates :name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :company, presence: true

  accepts_nested_attributes_for :company

  def total_hours(result = nil)
    total_punches = result.nil? ? self.punches : result
    total_sum = 0.0
    total_punches.each do |punch|
      total_sum = total_sum + (punch.to - punch.from)
    end
    total_sum / 3600
  end

  def self.find_for_googleapps_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']

    if user = User.where(:email => data['email']).first
      user
    else
      User.create! email: data['email'], name: data['name']
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
        user.email = data['email']
      end
    end
  end
end