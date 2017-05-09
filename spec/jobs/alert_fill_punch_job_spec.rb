require 'rails_helper'

RSpec.describe AlertFillPunchJob, type: :job do
  include ActiveJob::TestHelper
 describe '#perform' do

   let!(:user) { create(:user, active: true) }
   let!(:user2) { create(:user, active: false) }
   let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

   before do
     allow(message_delivery).to receive(:deliver_later)
   end

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('default')
    end

    it 'sends an email only to active users' do
      expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(user).and_return(message_delivery)

      expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch).with(user2)

      perform_enqueued_jobs { job }
    end
  end
end
