require 'spec_helper'

describe PunchesController do
  login_user

  describe "GET index" do
    let(:search) { double(:search) }
    let(:punches) { double(:punches) }

    context "without search" do
      it "renders current month" do
        expect(search).to receive(:sorts).and_return('from desc')
        expect(search).to receive(:result).and_return([double('punch')])
        expect(Punch).to receive(:search).with(nil).and_return(search)
        get :index
      end
    end

    context "with search" do
      it "renders selected month" do
        from_params = {
          "from_gteq(1i)" => '2013',
          "from_gteq(2i)" => '08',
          "from_gteq(3i)" => '01'
        }
        expect(search).to receive(:sorts).and_return('from desc')
        expect(search).to receive(:result).and_return([double('punch')])
        expect(Punch).to receive(:search).with(from_params).and_return(search)
        get :index, q: from_params
      end
    end
  end

  describe "POST create" do
    let(:company) { FactoryGirl.build(:company) }
    let(:project) { FactoryGirl.build(:project, company: company) }
    let(:punch) { double("Punch") }
    let(:user) { double(:current_user) }

    before do
      controller.stub(current_user: user)
      user.stub(company_id: company.id)
      user.stub(company: company)
    end

    context "when authorize pass" do
      before { controller.stub(authorize!: true) }
      it "creates" do
        punch_params = {
          :'from(4i)'  => '08',
          :'from(5i)'  => '00',
          :'to(4i)'    => '17',
          :'to(5i)'    => '00',
          :'project_id'=> project.id.to_s
        }
        params = {
          when_day: "2013-08-20",
          punch: punch_params
        }

        punch.should_receive(:company_id=).with(company.id)
        controller.stub_chain(:current_user, :punches,
                              :new => punch_params).and_return(punch)
        expect(punch).to receive(:save).and_return(true)
        post :create, params
        expect(assigns(:punch)).to eq(punch)
        expect(response).to redirect_to punch_url punch
      end

      it "does not create" do
        punch_params = {}
        controller.stub_chain(:current_user, :punches,
                              :new => punch_params).and_return(punch)
        punch.should_receive(:company_id=).with(company.id)
        expect(punch).to receive(:save).and_return(false)
        post :create, punch: punch_params
        expect(assigns(:punch)).to eq(punch)
        expect(response).to render_template(:new)
      end
    end

    context "when authorize fails" do
      it "must not create a punch" do
        punch_params = {
          :'from(4i)'  => '08',
          :'from(5i)'  => '00',
          :'to(4i)'    => '17',
          :'to(5i)'    => '00',
          :'project_id'=> project.id.to_s
        }
        params = {
          when_day: "2013-08-20",
          punch: punch_params
        }

        punch.should_receive(:company_id=).with(company.id)
        controller.stub_chain(:current_user, :punches,
                              :new => punch_params).and_return(punch)

        post :create, punch: punch_params
        expect(assigns(:punch)).to eq(punch)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update" do
    let(:project) { FactoryGirl.create(:project) }
    let(:punch) { FactoryGirl.create(:punch) }

    before do
      controller.current_user.stub(id: punch.user_id)
      controller.current_user.punches.stub(:find).with(punch.id.to_s) { punch }
      Punch.stub(:find).with(punch.id.to_s) { punch }
    end

    it "updates" do
      expect(punch).to receive(:update).and_return(true)
      put :update, {
        id: punch.id.to_s,
        when_day: '2013-08-20',
        punch: {
          :'from(4i)'   => '8',
          :'from(5i)'   => '0',
          :'to(4i)'     => '17',
          :'to(5i)'     => '0',
          :'project_id' => project.id.to_s
        }
      }
      expect(assigns(:punch)).to eq(punch)
      expect(response).to redirect_to punch_url(punch)
    end

    it "does not update do" do
      punch_params = {
        :'from(4i)'  => '08',
        :'from(5i)'  => '00',
        :'to(4i)'    => '17',
        :'to(5i)'    => '00',
        :'project_id'=> project.id.to_s
      }
      params = {
        id: punch.id,
        when_day: "",
        punch: punch_params
      }
      expect(punch).to receive(:update).and_return(false)
      put :update, params
      expect(assigns(:punch)).to eq(punch)
      expect(response).to render_template(:edit)
    end
  end

  describe "punch access control" do
    let(:own) { FactoryGirl.create(:user) }
    let(:not_own) { FactoryGirl.create(:user) }
    let(:punch) { FactoryGirl.create(:punch, user_id: own.id ) }

    context "user not own punch" do
      it "deny access" do
        sign_in not_own
        get :show, id: punch.id
        expect(response.code).to eq '403'
      end
    end

    context "user own punch" do
      it "allow access" do
        sign_in own
        get :show, id: punch.id
        expect(response.code).to eq '200'
      end
    end
  end

end
