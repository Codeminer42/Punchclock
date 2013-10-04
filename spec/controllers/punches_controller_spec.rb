require 'spec_helper'

describe PunchesController do
  login_user
  let(:user) { double(:current_user) }

  context "when user is admin" do
    before do
      user.stub(is_admin?: true)
    end

    describe "GET index" do
      let(:search) { double(:search) }
      context "with search" do
        it "renders current month" do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return([double('punch')])
          expect(Punch).to receive(:search).with(nil).and_return(search)
          get :index
        end


      end

      context "withou search" do
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
    end #END GET INDEX

    describe "GET new" do
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

      it "builds comment" do
        params = {
          id: 1
        }

        punch.should receive(:build_comment)
        get :edit, params
        response.should render_template :edit
      end
    end #END GET NEW

    describe "GET edit" do
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

      it "renders edit template" do
        params = {
          id: 1
        }

        get :edit, params
        response.should render_template :edit
      end

      it "builds comment if does not exist" do
        params = {
          id: 1
        }

        punch.should receive(:build_comment)
        get :edit, params
        response.should render_template :edit
      end
    end #END GET EDIT

    describe "methods" do

      let(:punch) { FactoryGirl.build(:punch) }
      let(:company) { punch.company }
      let(:project) { punch.project }
      let(:user) { punch.user }

      before do
        punch.stub(id: 1)
        controller.stub(current_user: user)
      end

      describe "POST create" do
        let(:punch_params) {
            {
              :'from(4i)'  => '08',
              :'from(5i)'  => '00',
              :'to(4i)'    => '17',
              :'to(5i)'    => '00',
              :'project_id'=> project.id.to_s
            }
        }
        let(:params) {
            params = {
              when_day: "2013-08-20",
              punch: punch_params
            }
        }

        context "when authorize pass" do
          it "creates" do
            punch.should_receive(:company_id=).with(company.id)
            controller.stub_chain(:current_user, :punches,
                                  :new => punch_params).and_return(punch)
            expect(punch).to receive(:save).and_return(true)
            post :create, params
            expect(assigns(:punch)).to eq(punch)
            expect(response).to redirect_to punch_url punch
          end
        end

        context "when authorize fails" do
          before { user.stub(company_id: punch.company.id - 1) }

          it "does not create" do
            punch.should_not receive(:save)
            post :create, params
            expect(response).to redirect_to(root_url)
          end
        end
      end #END POST CREATE

      describe "PUT update" do
        before do
          controller.stub_chain(:scopped_punches, find: punch)
          Punch.stub(find: punch)
        end

        let(:params) {
          {
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
        }


        it "updates" do
          put :update, params
          expect(response).to redirect_to punch_path(punch)
        end
      end #END PUT UPDATE
    end #END METHODS
  end

  context "when user is a employer" do
    before do
      user.stub(is_admin?: false)
    end

    describe "GET index" do
      let(:search) { double(:search) }
      context "with search" do
        it "renders current month" do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return([double('punch')])
          expect(Punch).to receive(:search).with(nil).and_return(search)
          get :index
        end


      end

      context "withou search" do
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
    end #END GET INDEX

    describe "GET new" do
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

      it "builds comment" do
        params = {
          id: 1
        }

        punch.should receive(:build_comment)
        get :edit, params
        response.should render_template :edit
      end
    end #END GET NEW

    describe "GET edit" do
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

      it "renders edit template" do
        params = {
          id: 1
        }

        get :edit, params
        response.should render_template :edit
      end

      it "builds comment if does not exist" do
        params = {
          id: 1
        }

        punch.should receive(:build_comment)
        get :edit, params
        response.should render_template :edit
      end
    end #END GET EDIT

    describe "methods" do

      let(:punch) { FactoryGirl.build(:punch) }
      let(:company) { punch.company }
      let(:project) { punch.project }
      let(:user) { punch.user }

      before do
        user.stub(is_admin?: false)
        punch.stub(id: 1)
        controller.stub(current_user: user)
      end

      describe "POST create" do
        let(:punch_params) {
            {
              :'from(4i)'  => '08',
              :'from(5i)'  => '00',
              :'to(4i)'    => '17',
              :'to(5i)'    => '00',
              :'project_id'=> project.id.to_s
            }
        }
        let(:params) {
            params = {
              when_day: "2013-08-20",
              punch: punch_params
            }
        }

        context "when authorize pass" do
          it "creates" do
            punch.should_receive(:company_id=).with(company.id)
            controller.stub_chain(:current_user, :punches,
                                  :new => punch_params).and_return(punch)
            expect(punch).to receive(:save).and_return(true)
            post :create, params
            expect(assigns(:punch)).to eq(punch)
            expect(response).to redirect_to punch_url punch
          end
        end

        context "when authorize fails" do
          before { user.stub(company_id: punch.company.id - 1) }

          it "does not create" do
            punch.should_not receive(:save)
            post :create, params
            expect(response).to redirect_to(root_url)
          end
        end
      end #END POST CREATE

      describe "PUT update" do
        before do
          controller.stub_chain(:scopped_punches, find: punch)
          Punch.stub(find: punch)
        end

        let(:params) {
          {
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
        }


        it "updates" do
          put :update, params
          expect(response).to redirect_to punch_path(punch)
        end
      end #END PUT UPDATE
    end #END METHODS
  end
end