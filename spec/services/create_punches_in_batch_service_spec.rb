require 'rails_helper'

RSpec.describe CreatePunchesInBatchService do
  describe '#call' do
    let(:error_message) { I18n.t('activerecord.errors.models.period.attributes.base.invalid_periods') }
    let(:user) { create(:user) }
    let(:project) { create(:project, company: user.company) }
    
    subject(:punches_transaction) { described_class.call(user.punches, user.company, additions, deletions) }
    
    context 'with valid data' do
      let(:deletions) { ['2022-05-16'] }
      let(:additions) {
        [
          { from: '2022-05-16T09:00:00.000Z', to: '2022-05-16T12:00:00.000Z', project_id: project.id },
          { from: '2022-05-16T13:00:00.000Z', to: '2022-05-16T18:00:00.000Z', project_id: project.id }
        ]
      }

      it 'returns success equals true' do
        expect(punches_transaction.success?).to be_truthy
      end
    end

    context 'when work periods are invalid' do
      context 'when both periods are equal' do
        let(:deletions) { ['2022-05-16'] }
        let(:additions) {
          [
            { from: '2022-05-16T09:00:00.000Z', to: '2022-05-16T09:00:00.000Z', project_id: project.id },
            { from: '2022-05-16T09:00:00.000Z', to: '2022-05-16T09:00:00.000Z', project_id: project.id }
          ]
        }
  
        it 'returns success equals false' do
          expect(punches_transaction.success?).to be_falsey
        end

        it 'returns error message' do
          expect(punches_transaction.errors).to include error_message
        end
      end

      context 'when from hour is greater than to hour' do
        let(:deletions) { ['2022-05-16'] }
        let(:additions) {
          [
            { from: '2022-05-16T09:00:00.000Z', to: '2022-05-16T08:00:00.000Z', project_id: project.id },
            { from: '2022-05-16T13:00:00.000Z', to: '2022-05-16T18:00:00.000Z', project_id: project.id }
          ]
        }
  
        it 'returns success equals false' do
          expect(punches_transaction.success?).to be_falsey
        end

        it 'returns error message' do
          expect(punches_transaction.errors).to include error_message
        end
      end
    end
  end
end