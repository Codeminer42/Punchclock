require 'rails_helper'

RSpec.describe AlertFillPunchJob, type: :job do
  describe '#perform' do
    subject(:perform) { described_class.perform_now(period) }

    # TODO: Add SPECS for the "end of month" use case
    let(:period) { 'fifteen' }
    let(:admin) { create(:user, :admin) }
    let(:active_user) { create(:user, active: true) }
    let(:inactive_user) { create(:user, active: false) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    it 'is in default queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('default')
    end

    context 'when is NOT working day' do
      before do
        allow(NotificationMailer).to receive(:notify_user_to_fill_punch).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
      end

      around do |example|
        travel_to Time.new(2019, 4, 21), &example
      end

      it 'does NOT send any emails' do
        expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch)

        perform
      end

      it 'reschedules to the next day' do
      end
    end

    context 'when is working day' do
      before do
        travel_to Time.new(2019, 6, 17)
        allow(NotificationMailer).to receive(:notify_user_to_fill_punch).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
      end

      after do
        travel_back
      end

      it 'sends an email only to active users' do
        expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(active_user)

        perform
      end

      it 'does not send an email to inactive users' do
        expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch).with(inactive_user)

        perform
      end

      it 'sends an email to admins' do
        expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(admin)

        perform
      end
    end
  end
end
