require 'rails_helper'

RSpec.describe SendEmailWithExtraHourJob, type: :job do

  describe '#perform' do
    
    let(:admin) { create :admin_user }
    let(:company) { admin.company }
    let(:active_user_with_hour) { create(:user, :active_user, company_id: company.id) }
    let(:active_user_without_hour) { create(:user, :active_user, company_id: company.id) }
    let(:inactive_user) { create(:user, :inactive_user, company_id: company.id, active: false) }
    let(:worked_days) { [2.weeks.ago.to_date.strftime("%d/%m/%Y") ] }

    let(:second_company) { create :company }
    let(:second_company_admin) { create(:admin_user, company_id: second_company.id) }

    before do
      allow(ExtraHourNotificationService).to receive(:call).and_return(nil)
    end

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(SendEmailWithExtraHourJob.new.queue_name).to eq('default')
    end

    it 'call Extra Hours Notification Service' do
      expect(ExtraHourNotificationService).to receive(:call)
      perform_enqueued_jobs { job }
    end

  end
end
