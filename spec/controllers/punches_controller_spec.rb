require 'spec_helper'

describe PunchesController do
  let(:user) { build_stubbed(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  context 'when user is a employer' do
    let(:punches) { double(:punch) }
    before do
      allow(punches).to receive(:decorate)
    end

    describe 'GET index' do
      let(:search) { double(:search) }
      context 'with search' do
        it 'renders current month' do
          expect(search).to receive(:sorts).and_return('from desc')
          expect(search).to receive(:result).and_return(punches)
          expect(Punch).to receive(:search).with(nil).and_return(search)
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
          expect(Punch).to receive(:search).with(from_params)
            .and_return(search)
          get :index, q: from_params
        end
      end
    end # END GET INDEX

    describe 'GET new' do
      let(:punch) { FactoryGirl.build(:punch) }

      before do
        allow(user).to receive_messages(id: punch.user.id)
        allow(user).to receive_messages(company: punch.company)
        allow(user).to receive_messages(company_id: punch.company.id)
        allow(punch).to receive_messages(id: 1)
        allow(controller).to receive_messages(current_user: user)
        allow(Punch).to receive(:find).with(punch.id.to_s) { punch }
        allow(controller).to receive_messages(load_and_authorize_resource: true)
      end
    end
    describe 'GET edit' do
      let(:punch) { FactoryGirl.build(:punch) }

      before do
        allow(user).to receive_messages(id: punch.user.id)
        allow(user).to receive_messages(company: punch.company)
        allow(user).to receive_messages(company_id: punch.company.id)
        allow(punch).to receive_messages(id: 1)
        allow(controller).to receive_messages(current_user: user)
        allow(Punch).to receive(:find).with(punch.id.to_s) { punch }
      end

      it 'renders edit template' do
        params = {
          id: 1
        }

        get :edit, params
        expect(response).to render_template :edit
      end
    end

    describe 'methods' do

      let(:punch) { FactoryGirl.build(:punch) }
      let(:company) { punch.company }
      let(:project) { punch.project }
      let(:user) { punch.user }

      before do
        allow(controller).to receive_messages(current_user: user)
      end

      describe 'POST #create' do
        def post_create
          post :create, punch: {}
        end

        before do
          allow(controller).to receive(:punch_params)
          allow(Punch).to receive(:new).and_return(punch)
          post_create
        end

        context 'when success' do
          it 'save and return to root_path' do
            allow(punch).to receive(:save).and_return(true)

            expect(response).to redirect_to punches_path
          end

          it "sets the 'from' attribute correctly" do
            expect(punch.from).to eq(DateTime.new(2001, 1, 1, 8, 0, 0, 0))
          end

          it "sets the 'to' attribute correctly" do
            expect(punch.to).to eq(DateTime.new(2001, 1, 1, 17, 0, 0, 0))
          end

          it "sets the 'extra_hour' attribute correctly" do
            expect(punch.extra_hour).to eq('01:25')
          end
        end

        context 'when fails' do
          it 'fail and render action new' do
            allow(punch).to receive(:save).and_return(false)
            allow(punch).to receive(:errors).and_return(['foo'])

            post_create
            expect(response).to render_template(:new)
          end
        end
      end

      describe 'PUT update' do
        let(:punch) { FactoryGirl.create(:punch) }

        before do
          allow(controller).to receive_message_chain(:scopped_punches, find: punch)
        end

        let(:params) do
          {
            id: punch.id,
            when_day: '2013-08-20',
            punch: {
              :'when_day' => DateTime.new(2001, 1, 1),
              :'from_time' => '10:00',
              :'to_time' => '14:00',
              :'extra_hour' => '02:00',
              :'project_id' => FactoryGirl.create(:project, company: user.company).id
            }
          }
        end

        context "when updating" do
          it "updates the 'from' attribute correctly" do
            expect { put :update, params }.to change { punch.reload.from }.
              from(DateTime.new(2001, 1, 1, 8, 0, 0, 0)).
                to(DateTime.new(2001, 1, 1, 10, 0, 0, 0))
          end

          it "updates the 'to' attribute correctly" do
            expect { put :update, params }.to change { punch.reload.to }.
              from(DateTime.new(2001, 1, 1, 17, 0, 0, 0)).
                to(DateTime.new(2001, 1, 1, 14, 0, 0, 0))
          end

          it "updates the 'extra_hour' attribute correctly" do
            expect { put :update, params }.to change { punch.reload.extra_hour }.
              from('01:25').to('02:00')
          end

          it "updates the project" do
            new_project = Project.find(params[:punch][:project_id])
            expect { put :update, params }.to change { punch.reload.project }.
              from(punch.project).to(new_project)
          end

          it "redirects to punches_path" do
            put :update, params
            expect(response).to redirect_to punches_path
          end
        end
      end
    end
  end
end
