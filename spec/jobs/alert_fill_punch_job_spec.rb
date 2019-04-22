require 'rails_helper'

RSpec.describe AlertFillPunchJob, type: :job do
  let(:job) { AlertFillPunchJob.new }

  describe '#perform' do
    let(:company) { create(:company, name: "Codeminer42") }
    let(:admin) { create(:admin_user, company: company) }
    let(:active_user) { create(:user, company: company, active: true) }
    let(:inactive_user) { create(:user, active: false) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    it 'is in default queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('default')
    end

    context 'when is NOT working day' do
      before do
        # allow(job).to receive(:is_working_day?).and_return(false)
        travel_to Time.new(2019, 4, 21)

        allow(NotificationMailer).to receive(:notify_user_to_fill_punch).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
      end

      after do
        travel_back
      end

      it 'does NOT send any emails' do
        expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch)

        job.perform
      end

      it 'reschedules to the next day' do
        # binding.pry
        # TODO
      end
    end

    context 'when is working day' do
      before do
        # allow(job).to receive(:is_working_day?).and_return(true)
        travel_to Time.new(2019, 6, 17)
        allow(NotificationMailer).to receive(:notify_user_to_fill_punch).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_later)
      end

      after do
        travel_back
      end

      it 'sends an email only to active users' do
        expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(active_user)

        job.perform
      end

      it 'does not send an email to inactive users' do
        expect(NotificationMailer).not_to receive(:notify_user_to_fill_punch).with(inactive_user)

        job.perform
      end

      it 'sends an email to admins' do
        expect(NotificationMailer).to receive(:notify_user_to_fill_punch).with(admin)

        job.perform
      end
    end
  end
end
