require 'rails_helper'

RSpec.describe AlertSendEmailJob, type: :job do
  let!(:admin_user) { create(:user, is_admin: true) }
  let!(:active_user) { create(:user, active: true) }
  let!(:inactive_user) { create(:user, active: false) }
  let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

  before do
    allow(NotificationMailer).to receive(:notify_admin_extra_hour).and_return(message_delivery)
    allow(message_delivery).to receive(:deliver_later)
  end

  subject(:job) { described_class.perform_later }

  it 'is in default queue' do
    expect(AlertSendEmailJob.new.queue_name).to eq('default')
  end
end
