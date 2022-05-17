# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveContributionReviewer, type: :service do
  describe '.call' do
    let!(:contribution) { create(:contribution) }

    context 'when the attributes are valid' do
      it 'updates reviewed_by attributes' do
        SaveContributionReviewer.call(contribution.id, contribution.user)
        expect { contribution.reload.reviewer_id }.to change {
                                                           contribution.reviewer_id
                                                         }.from(nil).to(contribution.user.id)
      end

      it 'updates reviewed_at attributes' do
        mock_time = Time.current.round
        travel_to(mock_time) do
          SaveContributionReviewer.call(contribution.id, contribution.user)
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
