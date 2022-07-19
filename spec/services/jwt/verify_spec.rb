require 'rails_helper'

RSpec.describe Jwt::Verify do
  describe '.call' do
    subject { described_class.call({ token: token }) }

    let(:token) { Jwt::Generate.new(user_id: 1, expire_at: exp_date).token }

    context 'when token is not expired' do
      let(:exp_date) { 1.week.from_now }
      it "does not raise error" do
        expect { subject }.not_to raise_error(JWT::DecodeError)
      end

      it "returns user_id" do
        expect(subject).to eq(1)
      end
    end

    context "when token is expired" do
      let(:exp_date) { 2.week.ago }


      it 'raises an InvalidError' do
        expect { subject }.to raise_error(Jwt::Verify::InvalidError)
      end
    end
  end

end
