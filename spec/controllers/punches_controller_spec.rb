require 'spec_helper'

describe PunchesController do
  let(:user) { build_stubbed(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  context 'when user is an employee' do
    let(:punches) { double(:punch, page: Punch.page) }

    before do
      allow(punches).to receive(:decorate)
    end

    describe 'GET index' do
      let(:search) { double(:search) }
      context 'with search' do
        it 'renders current month' do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
          expect(Punch).to receive(:ransack).with(nil).and_return(search)
          get :index
        end

      end

      context 'without search' do
        it 'renders selected month' do
          from_params = {
            'from_gteq(1i)' => '2013',
            'from_gteq(2i)' => '08',
            'from_gteq(3i)' => '01'
          }
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
          expect(Punch).to receive(:ransack).with(ActionController::Parameters.new(from_params))
            .and_return(search)

          get :index, params:{ q: from_params }
        end
      end

      context 'with many punches' do
        it 'paginates' do
          FactoryBot.create_list(:punch, 5, user: user)

          params = { per: 3 }
          get :index, params: params

          expect(assigns(:punches))
            .to match_array(Punch.limit(3).decorate)
        end
      end
    end

    describe 'GET new' do
      let(:punch) { FactoryBot.build(:punch) }

      before do
        allow(user).to receive_messages(id: punch.user.id)
        allow(punch).to receive_messages(id: 1)
        allow(controller).to receive_messages(current_user: user)
        allow(Punch).to receive(:find).with(punch.id.to_s) { punch }
        allow(controller).to receive_messages(load_and_authorize_resource: true)
      end
    end
    describe 'GET edit' do
      let(:punch) { FactoryBot.build(:punch) }

      before do
        allow(user).to receive_messages(id: punch.user.id)
        allow(punch).to receive_messages(id: 1)
        allow(controller).to receive_messages(current_user: user)
        allow(Punch).to receive(:find).with(punch.id.to_s) { punch }
      end

      it 'renders edit template' do
        params = {
          id: 1
        }

        get :edit, params: params
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      let(:user) { create(:user) }
      let(:project) { create(:project) }
      
      subject { post :create, params: { punch: punch_params } }
      
      before { login(user) }

      context 'when success' do
        let(:punch_params) { 
          {
            "from_time"=>"08:00", 
            "to_time"=>"18:00", 
            "when_day"=>"02/01/2020",
            "project_id" => "#{project.id}"
          }
        }
        
        it { expect { subject }.to change(Punch, :count).by(1) }
        it { is_expected.to redirect_to(punches_path) }
        it 'creates a new punch attributes' do
          subject
          expect(assigns(:punch)).to have_attributes(
            from: Time.utc(2020, 1, 2, 8, 0, 0),
            to: Time.utc(2020, 1, 2, 18, 0, 0),
            project_id: project.id,
            user_id: user.id,
            extra_hour: false
          )
        end
      end

      context 'when fails' do
        let(:punch_params) { 
          {
            "from_time"=>"04:00", 
            "to_time"=>"18:00", 
            "when_day"=>"01/01/2020",
            "project_id" => "#{project.id}"
          }
        }

        it 'fail and render action new' do
          is_expected.to render_template(:new) 
        end
      end
    end    

    describe 'methods' do

      let(:punch) { FactoryBot.build(:punch) }
      let(:project) { punch.project }
      let(:user) { punch.user }

      before do
        allow(controller).to receive_messages(current_user: user)
      end



      describe 'PUT update' do
        let(:punch) { FactoryBot.create(:punch) }

        before do
          allow(controller).to receive_message_chain(:scopped_punches, find: punch)
        end

        let(:params) do
          {
            id: punch.id,
            when_day: '2013-08-20',
            punch: {
              :'when_day' => DateTime.new(2001, 1, 5),
              :'from_time' => '10:00',
              :'to_time' => '14:00',
              :'extra_hour' => true,
              :'project_id' => FactoryBot.create(:project).id
            }
          }
        end

        context "when updating" do
          it "updates the 'from' attribute correctly" do
            expect { put :update, params: params }.to change { punch.reload.from }.
              from(DateTime.new(2001, 1, 5, 8, 0, 0, 0)).
                to(DateTime.new(2001, 1, 5, 10, 0, 0, 0))
          end

          it "updates the 'to' attribute correctly" do
            expect { put :update, params: params }.to change { punch.reload.to }.
              from(DateTime.new(2001, 1, 5, 17, 0, 0, 0)).
                to(DateTime.new(2001, 1, 5, 14, 0, 0, 0))
          end

          it "updates the 'extra_hour' attribute correctly" do
            expect { put :update, params: params }.to change { punch.reload.extra_hour }.
              from(false).to(true)
          end

          it "updates the project" do
            new_project = Project.find(params[:punch][:project_id])
            expect { put :update, params: params }.to change { punch.reload.project }.
              from(punch.project).to(new_project)
          end

          it "redirects to punches_path" do
            put :update, params: params
            expect(response).to redirect_to punches_path
          end
        end
      end
    end
  end
end
