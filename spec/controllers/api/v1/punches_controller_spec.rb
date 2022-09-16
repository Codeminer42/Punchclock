require 'spec_helper'

describe Api::V1::PunchesController, :type => :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  describe 'GET api/v1/punches' do
    subject { get :index }
    before { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
      before { use_auth_header_for(user.id) }

      include_examples 'an authenticated resource action'

      it { is_expected.to have_http_status(:ok) }

      it 'returns all punches for the current user' do
        expect(JSON.parse(subject.body)).to all(include('created_at', 'delta_as_hour', 'extra_hour', 'from', 'project', 'to'))
      end
    end

    context 'when user is not logged in' do
      include_examples 'an unauthenticated resource action'
    end
  end

  describe 'POST api/v1/punches/bulk' do
    context 'when api token is valid and params are valid' do
      let(:params) do
        {
          'punches' => [
            {
              'from' => '2022-04-19T12:00:00.000Z',
              'to' => '2022-04-19T15:00:00.000Z',
              'project_id' => project.id
            },
            {
              'from' => '2022-04-19T16:00:00.000Z',
              'to' => '2022-04-19T21:00:00.000Z',
              'project_id' => project.id
            }
          ]
        }
      end

      subject { post :bulk, params: params }
      before { use_auth_header_for(user.id) }

      include_examples 'an authenticated create resource action'

      it 'returns created punches' do
        created_punches = JSON.parse(subject.body)
        expect(created_punches).to match_array(
          [
            hash_including(
              {
                'from' => '2022-04-19T12:00:00.000Z',
                'to' => '2022-04-19T15:00:00.000Z',
                'project' => hash_including({ 'id' => project.id })
              }
            ),
            hash_including(
              {
                'from' => '2022-04-19T16:00:00.000Z',
                'to' => '2022-04-19T21:00:00.000Z',
                'project' => hash_including({ 'id' => project.id })
              }
            )
          ]
        )
      end
    end

    context 'when api token is valid, params are valid and there are punches on the same day' do
      let(:params) do
        {
          punches: [
            {
              'from' => '2022-04-19T10:00:00.000Z',
              'to' => '2022-04-19T12:00:00.000Z',
              'project_id' => project.id
            }
          ]
        }
      end

      subject { post :bulk, params: params }
      before do
        use_auth_header_for(user.id)

        create(:punch, from: '2022-04-19T12:00:00', to: '2022-04-19T15:00:00', project: project, user: user)
      end

      include_examples 'an unprocessable entity error'

      it 'returns "duplicated punch" message' do
        expect(JSON.parse(subject.body)).to eq('from' => ['There is already a punch on the same day'])
      end
    end

    context 'when api token is missing' do
      subject { post :bulk }

      include_examples 'an unauthenticated resource action'
    end
  end

  describe 'GET api/v1/punches/:id' do
    subject { get :show, params: { id: punch.id } }
    let(:punch) { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
      let(:headers) { { token: user.token } }

      before { use_auth_header_for(user.id) }

      include_examples 'an authenticated resource action'

      it { is_expected.to have_http_status(:found) }

      it 'returns selected punch for the current user' do
        expect(JSON.parse(subject.body)).to include('created_at', 'delta_as_hour', 'extra_hour', 'from', 'project', 'to')
      end
    end

    context 'when user is not logged in' do
      include_examples 'an unauthenticated resource action'
    end
  end
end
