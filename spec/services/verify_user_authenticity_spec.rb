require 'rails_helper'

RSpec.describe VerifyUserAuthenticity do
  subject(:result) { described_class.call(**params) { |r| r } }

  let!(:user) do
    create(
      :user,
      email: 'example@cm42.com',
      password: 'password',
      otp_secret: 'secret',
      otp_required_for_login: otp_required
    )
  end

  context 'when otp code is required' do
    let(:otp_required) { true }

    describe 'but no otp code was given' do
      let(:params) do
        {
          email: user.email,
          password: user.password,
          user_id: nil,
          otp_attempt: nil
        }
      end

      it { expect(result.authenticate?).to be(true) }
      it { expect(result.valid_otp?).to be(false) }
      it { expect(result.otp_required_for_login?).to be(true) }
    end

    describe 'and the otp code was given' do
      let(:params) do
        {
          email: nil,
          password: nil,
          user_id: user.id,
          otp_attempt: user.current_otp
        }
      end

      it { expect(result.authenticate?).to be(false) }
      it { expect(result.valid_otp?).to be(true) }
      it { expect(result.otp_required_for_login?).to be(true) }
    end
  end

  context 'when otp code is not required' do
    let(:otp_required) { false }

    let(:params) do
      {
        email: user.email,
        password: user.password,
        user_id: nil,
        otp_attempt: nil
      }
    end

    it { expect(result.authenticate?).to be(false) }
    it { expect(result.otp_required_for_login?).to be(false) }
  end
end
