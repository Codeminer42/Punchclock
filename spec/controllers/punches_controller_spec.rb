require 'spec_helper'

describe PunchesController do
  let(:user) { build_stubbed(:user) }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:current_user).and_return(user)
  end

  context "when user is admin" do
    let(:punches) { double(:punch)}
    before do
      user.stub(is_admin?: true)
      punches.stub(:decorate)
    end

    describe "GET index" do
      let(:search) { double(:search) }

      context "with search" do
        it "renders current month" do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
          expect(Punch).to receive(:search).with(nil).and_return(search)
          get :index
        end
      end

      context "without search" do

        it "renders selected month" do
          from_params = {
            "from_gteq(1i)" => '2013',
            "from_gteq(2i)" => '08',
            "from_gteq(3i)" => '01'
          }
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
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

      it "renders new template" do
        get :new
        response.should render_template :new
      end

      context "when has a last project punched" do
        before do
          Punch.stub(:find_last_by_user_id).with(punch.user_id) { punch }
        end

        it "builds punch with last project punched" do
          get :new
          last_project_id = Punch.find_last_by_user_id(punch.user_id).project_id
          punch.project_id.should eq last_project_id
        end
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

      describe "POST #create" do
        def post_create
          post :create, punch: {}
        end

        before do
          controller.stub(:punch_params)
          Punch.should_receive(:new).and_return(punch)
        end

        context "when success" do
          before do
            expect(punch).to receive(:save).and_return(true)
          end

          it "saves the punch and redirect to punches_path" do
            post_create
            expect(response).to redirect_to punches_path
          end
        end

        context "when fails" do
          before do
            expect(punch).to receive(:save).and_return(false)
            punch.stub(:errors).and_return(['foo'])
          end

          it "renders the action new" do
            post_create
            expect(response).to render_template(:new)
          end
        end
      end

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
          expect(response).to redirect_to punches_path
        end
      end #END PUT UPDATE
    end #END METHODS
  end

  context "when user is a employer" do
    let(:punches) { double(:punch)}
    before do
      user.stub(is_admin?: false)
      punches.stub(:decorate)
    end

    describe "GET index" do
      let(:search) { double(:search) }
      context "with search" do
        it "renders current month" do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
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
          expect(search).to receive(:result).and_return(punches)
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
    end
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
    end

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

      describe "POST #create" do
        def post_create
          post :create, punch: {}
        end

        before do
          controller.stub(:punch_params)
          Punch.should_receive(:new).and_return(punch)
        end

        context "when success" do
          before do
            expect(punch).to receive(:save).and_return(true)
          end

          it "save and return to root_path" do
            post_create
            expect(response).to redirect_to punches_path
          end
        end

        context "when fails" do
          before do
            expect(punch).to receive(:save).and_return(false)
            punch.stub(:errors).and_return(['foo'])
          end

          it "fail and render action new" do
            post_create
            expect(response).to render_template(:new)
          end
        end
      end

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
          expect(response).to redirect_to punches_path
        end
      end #END PUT UPDATE
    end #END METHODS
  end
end
