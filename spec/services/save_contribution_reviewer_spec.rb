# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveContributionReviewer, type: :service do
  describe '.call' do
    subject(:call) { described_class.call(contribution.id, contribution.user) }
    let(:contribution) { create(:contribution) }

    context 'when the attributes are valid' do
      it 'updates reviewed_by attributes' do
        call
        expect { contribution.reload.reviewer_id }.to change {
                                                        contribution.reviewer_id
                                                      }.from(nil).to(contribution.user.id)
      end

      it 'updates reviewed_at attributes' do
        mock_time = Time.current.round
        travel_to(mock_time) do
          call
          contribution.reload
          expect(contribution.reviewed_at).to eq(mock_time)
        end
      end
    end

    context 'when the attributes are invalid' do
      it 'raises an error' do
        expect { SaveContributionReviewer.call(contribution.id, nil) }.to raise_error(NoMethodError)
      end
    end
  end
end
