require 'rails_helper'

RSpec.describe AlertFillPunchJob, type: :job do

  describe '#perform' do

    let!(:company) { create(:company, name: "Codeminer42") }
    let!(:admin) { create(:admin_user, company: company) }
    let!(:active_user) { create(:user, company: company, active: true) }
    let!(:inactive_user) { create(:user, active: false) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    before do
      allow(NotificationMailer).to receive(:notify_user_to_fill_punch).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_later)
    end

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('default')
    end

    it 'sends an email only to active users' do
      expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(active_user)

      perform_enqueued_jobs { job }
    end

    it 'does not send an email to inactive users' do
      expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch).with(inactive_user)

      perform_enqueued_jobs { job }
    end

    it 'sends an email to admins' do
      expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(admin)

      perform_enqueued_jobs { job }
    end
  end
end
