require 'rails_helper'

describe VacationsController do
  let(:user) { create(:user) }
  let(:user_p) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET index' do
    let!(:vacation) { create(:vacation, user: user) }

    it "returns successful status" do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it "returns user's vacation" do
      get :index

      expect(subject.instance_variable_get(:@vacations)).to include(vacation)
    end
  end

  describe 'GET show' do
    let(:vacation1) { create(:vacation, user: user) }
    let(:vacation2) { create(:vacation, user: user) }

    it "returns successful status" do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it "returns a specific user's vacation" do
      get :show, params: { id: vacation1.id }

      expect(subject.instance_variable_get(:@vacation)).to eq(vacation1)
    end
  end

  describe 'GET new' do
    it "render the create form" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    context "when params are valid" do
      let(:admins) { [create(:user, :hr), create(:user, :project_manager)] }
      let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

      let(:vacation_valid_params) do
        {
          start_date: 1.months.from_now,
          end_date: 2.months.from_now
        }
      end

      before do
        allow(VacationMailer).to receive(:notify_vacation_request).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
      end

      it "saves the user vacation" do
        post :create, params: { vacation: vacation_valid_params }

        expect(response).to have_http_status(:found)
      end

      it "mails admins" do
        expect(VacationMailer).to receive(:notify_vacation_request)

        post :create, params: { vacation: vacation_valid_params }
      end
    end

    context "when params are invalid" do
      let(:vacation_invalid_params) do
          {
            start_date: nil,
            end_date: nil
          }
      end

      it 'fail and render action new' do
        post :create, params: { vacation: vacation_invalid_params }

        is_expected.to render_template(:new)
      end
    end
  end

  describe 'DELETE cancel' do
    context "when vacation in cancelable" do
      let(:vacation) { create(:vacation, user: user, status: :pending) }
      let(:params) { { id: vacation.id } }
      let(:message_delivery) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

      before do
        allow(VacationMailer).to receive(:notify_vacation_cancelled).and_return(message_delivery)
      end

      it "cancels the user vacation" do
        expect{ delete :destroy, params: params }.to change { vacation.reload.status }
        .from('pending').to('cancelled')
      end

      it "calls VacationMailer#notify_vacation_cancelled" do
        expect(VacationMailer).to receive(:notify_vacation_cancelled)

        delete :destroy, params: params
      end

      it "flash success message" do
        delete :destroy, params: params

        expect(flash[:notice]).to eq(I18n.t(:notice, scope: "flash.vacation.cancel"))
      end
    end

    context "when vacation is not cancelable" do
      let(:vacation) { create(:vacation, user: user, status: :approved) }
      let(:params) { { id: vacation.id } }

      it "do not change vacation status" do
        expect{ delete :destroy, params: params }.to_not change { vacation.reload.status }
      end

      it "flash denied message" do
        delete :destroy, params: params

        expect(flash[:alert]).to eq(I18n.t(:alert, scope: "flash.vacation.cancel"))
      end
    end
  end
end
