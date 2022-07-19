require 'rails_helper'

RSpec.describe Jwt::Generate do
  describe '.token' do
    subject { described_class.new(user_id: 1, expire_at: exp_date).token }

    context 'when token is not expired' do
      let(:exp_date) { 1.week.from_now }
      it "returns a valid token" do
        expect { JWT.decode(subject, ENV['JWT_SECRET_KEY']) }.not_to raise_error(JWT::DecodeError)
      end
    end
  end
end
