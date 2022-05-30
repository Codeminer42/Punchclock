require 'rails_helper'

RSpec.describe BulkPunchesService do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  describe '#call' do
    context 'with right arguments' do
      let(:punches) do
        [
          {
            'from' => '2022-04-19T12:00:00.000Z'.to_datetime,
            'to' => '2022-04-19T15:00:00.000Z'.to_datetime,
            'project_id' => project.id
          },
          {
            'from' => '2022-04-19T16:00:00.000Z'.to_datetime,
            'to' => '2022-04-19T21:00:00.000Z'.to_datetime,
            'project_id' => project.id
          }
        ]
      end

      it 'returns the created punches' do
        result = described_class.call(punches, user)

        created_punches = result.map { |punch| punch.slice(:from, :to, :project_id) }
        expect(created_punches).to match_array(punches)
      end
    end

    context 'when does have another punch on same date' do
      let(:punches) do
        [
          {
            'from' => '2022-04-19T10:00:00.000Z'.to_datetime,
            'to' => '2022-04-19T12:00:00.000Z'.to_datetime,
            'project_id' => project.id
          },
          {
            'from' => '2022-04-19T15:00:00.000Z'.to_datetime,
            'to' => '2022-04-19T20:00:00.000Z'.to_datetime,
            'project_id' => project.id
          }
        ]
      end

      before do
        create(:punch, from: '2022-04-19T12:00:00', to: '2022-04-19T15:00:00', project: project, user: user)
        create(:punch, from: '2022-04-19T16:00:00', to: '2022-04-19T21:00:00', project: project, user: user)
      end

      it 'raises "duplicated punch" error' do
        expect { described_class.call(punches, user) }.to raise_error('There is already a punch on the same day')
      end
    end
  end
end
