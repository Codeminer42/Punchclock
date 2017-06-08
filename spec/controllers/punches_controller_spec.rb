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

      context 'withou search' do
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
        allow(punch).to receive_messages(id: 1)
        allow(controller).to receive_messages(current_user: user)
      end

      describe 'POST #create' do
        def post_create
          post :create, punch: {}
        end

        before do
          allow(controller).to receive(:punch_params)
          allow(Punch).to receive(:new).and_return(punch)
        end

        context 'when success' do
          it 'save and return to root_path' do
            allow(punch).to receive(:save).and_return(true)

            post_create
            expect(response).to redirect_to punches_path
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
        before do
          allow(controller).to receive_message_chain(:scopped_punches, find: punch)
          allow(Punch).to receive_messages(find: punch)
        end

        let(:params) do
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
        end

        it 'updates' do
          put :update, params
          expect(response).to redirect_to punches_path
        end
      end # END PUT UPDATE
    end # END METHODS
  end
end
