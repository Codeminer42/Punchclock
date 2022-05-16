# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewersService, type: :service do
  describe '.save_review' do
    let!(:contribution) { create(:contribution) }

    context 'when the attributes are valid' do
      it 'updates reviewed_by attributes' do
        ReviewersService.save_review(contribution.id, contribution.user)
        expect { contribution.reload.reviewed_by_id }.to change {
                                                           contribution.reviewed_by_id
                                                         }.from(nil).to(contribution.user.id)
      end

      it 'updates reviewed_at attributes' do
        mock_time = Time.current.round
        travel_to(mock_time) do
          ReviewersService.save_review(contribution.id, contribution.user)
          contribution.reload
          expect(contribution.reviewed_at).to eq(mock_time)
        end
      end
    end

    context 'when the attributes are invalid' do
      it 'raises an error' do
        expect { ReviewersService.save_review(nil, nil) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
