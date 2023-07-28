require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  before { login user }

  describe 'PUT update' do
    context 'with valid information' do
      let(:user_attributes) { { name: '1234', email: '1234@1234.com' } }

      it 'should update user' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(controller.current_user).to have_attributes(user_attributes)
      end

      it 'redirects to root_path' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid information' do
      let(:user_attributes) { { name: '1234', email: '1234@' } }

      it 'renders "edit" template ' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'GET enable 2FA' do
    before do
      allow(QrCodeGeneratorService)
        .to receive(:call)
        .and_return('fake_image_data')
    end

    context 'with valid information' do
      it 'renders "two_factor" view' do
        get :two_factor

        expect(response).to render_template 'two_factor'
        expect(assigns(:image_data)).to eq('fake_image_data')
      end
    end
  end

  describe 'POST confirm otp' do
    before do
      set_2fa
    end

    context 'with valid information' do
      it 'redirects to root_path' do
        post :confirm_otp, params: { otp_attempt: user.current_otp }

        expect(response).to redirect_to backup_codes_path
      end
    end

    context 'with invalid information' do
      it 'renders "two_factor" view' do
        otp = user.current_otp

        post :confirm_otp, params: { otp_attempt: suffle_otp(otp) }

        expect(response).to redirect_to two_factor_path
      end
    end
  end

  describe 'GET disable 2FA' do
    it 'renders the deactivate 2FA view' do
      get :deactivate_two_factor

      expect(response).to render_template 'deactivate_two_factor'
    end
  end

  describe 'POST disable 2FA' do
    before do
      set_2fa
    end

    context 'with valid information' do
      it 'deactivate 2FA' do
        post :deactivate_otp, params: { otp_attempt: user.current_otp }

        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid info' do
      it 'does not deactivate 2FA' do
        otp = user.current_otp
        post :deactivate_otp, params: { otp_attempt: otp.chars.shuffle.join }

        expect(response).to redirect_to deactivate_two_factor_path
      end
    end
  end

  def set_2fa
    user.otp_secret = user.class.generate_otp_secret
    user.save
  end
end
