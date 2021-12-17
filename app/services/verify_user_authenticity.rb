class VerifyUserAuthenticity
  Result = Struct.new(:user, :otp_attempt, :password) do
    def otp_required_for_login?
      user.otp_required_for_login?
    end

    def authenticate?
      otp_required_for_login? && !otp_attempt &&
        user.valid_password?(password)
    end

    def valid_otp?
      user.validate_and_consume_otp!(otp_attempt) ||
        user.invalidate_otp_backup_code!(otp_attempt)
    end
  end

  NilResult = Struct.new(:user, :otp_attempt, :password) do
    def otp_required_for_login?; false end
    def authenticate?; false end
    def valid_otp?; false end
  end

  def self.call(email:, password:, user_id:, otp_attempt:, &block)
    new(email, password, user_id, otp_attempt).call(&block)
  end

  def initialize(email, password, user_id = nil, otp_attempt = nil)
    @email = email
    @password = password
    @user_id = user_id
    @otp_attempt = otp_attempt
  end

  def call
    if (user = find_user)
      yield Result.new(user, @otp_attempt, @password)
    else
      yield NilResult.new
    end
  end

  private

  def find_user
    if @email
      User.find_by(email: @email)
    elsif @user_id
      User.find(@user_id)
    end
  end
end
