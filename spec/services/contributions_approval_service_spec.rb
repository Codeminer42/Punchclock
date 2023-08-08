# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsApprovalService do
  describe '#self.call' do
    let(:user) { create(:user) }
    let(:contribution) { create(:contribution) }

    it 'updates reviewer_id' do
      expect do
        described_class.call(contribution, reviewer_id: user.id)
      end.to change { contribution.reload.reviewer_id }.from(nil).to(user.id)
    end

    it 'updates reviewed_at' do
      expect do
        described_class.call(contribution, reviewer_id: user.id)
      end.to change { contribution.reload.reviewed_at }.from(nil)
    end

    it 'updates tracking' do
      expect do
        described_class.call(contribution, reviewer_id: user.id)
      end.to change { contribution.reload.tracking }.from(false).to(true)
    end
  end
end
