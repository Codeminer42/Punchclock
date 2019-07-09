require 'rails_helper'

RSpec.describe AlertFillPunchJob, type: :job do

  describe '#perform' do
    let!(:company) { create(:company, name: "Codeminer42") }
    let(:admin) { create(:user, :admin, company: company) }
    let(:active_user) { create(:user, company: company, active: true) }
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
        subject.perform
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
        subject.perform
      end

      it 'does not send an email to inactive users' do
        expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch).with(inactive_user)
        subject.perform
      end

      it 'sends an email to admins' do
        expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(admin)
        subject.perform
      end
    end
  end
end
