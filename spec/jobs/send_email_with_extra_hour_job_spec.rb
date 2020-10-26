require 'rails_helper'

RSpec.describe SendEmailWithExtraHourJob, type: :job do
  describe '#perform' do
    let!(:company) { create :company, name: 'Codeminer42' }
    let!(:admins) do
      [
        create(:user, :admin, email: 'active@codeminer42.com', company: company, active: true),
        create(:user, :admin, email: 'inactive@codeminer42.com', company: company, active: false),
      ]
    end
    let!(:active_user) { create :user, company: company, active: true, allow_overtime: true }
    let!(:extra_hour_punches) do
      from = Time.new 2018, 7, 3, 17, 0
      to = from + 2.hours
      create_list :punch, 1, extra_hour: true, user: active_user, from: from, to: to
    end
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    before do
      allow(Time).to receive(:now).and_return(Time.new 2018, 7, 25, 17, 0)
      allow(NotificationMailer).to receive(:notify_admin_extra_hour).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_later)
    end

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(SendEmailWithExtraHourJob.new.queue_name).to eq('default')
    end

    it 'executes perform' do
      expect(NotificationMailer).to receive(:notify_admin_extra_hour)
          .with(
            [[active_user.name, extra_hour_punches]],
            a_collection_containing_exactly(
              'active@codeminer42.com'
            )
          )

      perform_enqueued_jobs { job }
    end
  end
end
