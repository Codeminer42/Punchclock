require 'rails_helper'

RSpec.describe SendEmailWithExtraHourJob, type: :job do

  describe '#perform' do
    let(:admin) { create :admin_user }
    let(:company) { admin.company }
    let(:active_user_with_hour) { create(:user, :active_user, company_id: company.id) }
    let(:active_user_without_hour) { create(:user, :active_user, company_id: company.id) }
    let(:inactive_user) { create(:user, :inactive_user, company_id: company.id, active: false) }
    let(:worked_days) { ['10/05/2017'] }

    before do
      create(:punch, from: '2017-05-10 08:00', to: '2017-05-10 12:00', user: active_user_with_hour, company: company)
      create(:punch, from: '2017-05-10 13:00', to: '2017-05-10 18:00', user: active_user_with_hour, company: company)
      create(:punch, from: '2017-05-11 08:00', to: '2017-05-11 12:00', user: active_user_with_hour, company: company)

      create(:punch, from: '2017-05-10 08:00', to: '2017-05-10 12:00', user: active_user_without_hour, company: company)
      create(:punch, from: '2017-05-10 13:00', to: '2017-05-10 17:00', user: active_user_without_hour, company: company)
      create(:punch, from: '2017-05-11 08:00', to: '2017-05-11 12:00', user: active_user_without_hour, company: company)
    end

    before do
      allow(NotificationMailer).to receive(:notify_admin_extra_hour).and_return(double.as_null_object)
    end

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(SendEmailWithExtraHourJob.new.queue_name).to eq('default')
    end

    it 'sends an email when user have more than 8 hours' do
      expect(NotificationMailer).to receive(:notify_admin_extra_hour).with(admin, active_user_with_hour, worked_days)
      perform_enqueued_jobs { job }
    end

    it 'do not sends an email when user have 8 hours or less' do
      expect(NotificationMailer).not_to receive(:notify_admin_extra_hour).with(admin, active_user_without_hour, worked_days)
      perform_enqueued_jobs { job }
    end

    it 'do not sends an email to inactive_user' do
      expect(NotificationMailer).not_to receive(:notify_admin_extra_hour).with(admin, inactive_user, worked_days)
      perform_enqueued_jobs { job }
    end

  end
end
