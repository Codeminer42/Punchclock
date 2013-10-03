require 'spec_helper'

describe PunchesController do
  login_user

  describe "GET index" do
    let(:search) { double(:search) }

    context "without search" do

      it "renders current month" do
        expect(search).to receive(:sorts).and_return('from desc')
        expect(search).to receive(:result).and_return([double('punch')])
        expect(Punch).to receive(:search).with(nil).and_return(search)
        get :index
      end

      describe "with multiuser selection" do
        let(:user) { FactoryGirl.build(:user) }

        before do
          double(current_user: user)
        end

        context "when user is admin" do
          before { user.stub(is_admin?: true) }

          it "returns punches of a company" do
            get :index
            assigns(:punches).should eq(user.company.punches.to_a)
          end
        end

        context "when user is a employer of a company" do
          it "returns punches of the user" do
            get :index
            assigns(:punches).should eq(user.punches.to_a)
          end
        end
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

  describe "GET edit" do
    let(:user) { double(:current_user) }
    let(:punch) { FactoryGirl.build(:punch) }

    before do
      user.stub(id: punch.user.id)
      user.stub(company: punch.company)
      user.stub(company_id: punch.company.id)
      user.stub(is_admin?: false)
      punch.stub(id: 1)
      controller.stub(current_user: user)
      Punch.stub(:find).with(punch.id.to_s) { punch }
      controller.stub(load_and_authorize_resource: true)
    end

    it "builds comment if does not exist" do
      params = {
        id: 1
      }

      punch.should receive(:build_comment)
      get :edit, params
      response.should render_template :edit
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
      user.stub(is_admin?: false)
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
        punch_params = { punch: {} }
        controller.stub_chain(:current_user, :punches,
                              :new => punch_params).and_return(punch)
        punch.should_receive(:company_id=).with(company.id)
        expect(punch).to receive(:save).and_return(false)
        post :create, punch: punch_params
        expect(assigns(:punch)).to eq(punch)
        expect(response).to render_template(:new)
      end

      context "with comment" do
        before do
          user.stub(id: 1)
        end

        it "creates a punch with comment" do
          punch_params = {
            :'from(4i)'  => '08',
            :'from(5i)'  => '00',
            :'to(4i)'    => '17',
            :'to(5i)'    => '00',
            :'project_id'=> project.id.to_s,
            comment_attributes: {
              text:'a comment'
            }
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
      end
    end

    context "when authorize fails" do
      before { user.stub(id: 1) }
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
    let(:punch) { FactoryGirl.create(:punch) }
    let(:project) { punch.project }
    let(:user) { punch.user }

    before do
      controller.stub(authorize!: true)
      user.stub(is_admin?: false)
      controller.stub(current_user: user)
      Punch.stub(:find).with(punch.id.to_s) { punch }
    end

    context "when user is employer" do
      it "updates" do
        params = {
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

        put :update, params
        expect(response).to redirect_to punch_path(punch)
      end
    end

    context "when user is admin" do
      before do
        user.stub(is_admin?: true)
        controller.stub_chain(:current_user, :company, :punches, find: punch)
        controller.stub(user_projects: true)
      end

      it "updates" do
        params = {
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

        put :update, params
        expect(response).to redirect_to punch_path(punch)
      end
    end
  end
end
