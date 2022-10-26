require 'rails_helper'

describe VacationsController do
  let(:user) {create(:user)}

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET index' do
    let!(:vacation) {create(:vacation, user: user)}

    it "returns all user's vacations" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    let(:vacation) {create(:vacation, user: user)}

    it "returns a specific user vacation" do
      get :show, params: {id: vacation.id}

      expect(response).to have_http_status(:ok)
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
      let(:vacation) {build(:vacation)}

      it "saves the user vacation" do
        post :create, params: {vacation: vacation.attributes}

        expect(response).to have_http_status(:found)
      end
    end

    context "when params are invalid" do
      context "when start date invalid" do

      end

      context "when end date invalid" do

      end


      let(:vacation) {build(:vacation, start_date: nil, end_date: nil)}
    end



  end

  describe 'DELETE cancel' do




  end







end
