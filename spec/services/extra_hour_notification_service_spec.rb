require 'rails_helper'

RSpec.describe ExtraHourNotificationService do

  describe '#call' do
    
    let(:admin) { create :admin_user }
    let(:company) { admin.company }
    let(:active_user_with_hour) { create(:user, :active_user, company_id: company.id) }
    let(:active_user_without_hour) { create(:user, :active_user, company_id: company.id) }
    let(:inactive_user) { create(:user, :inactive_user, company_id: company.id, active: false) }
    let(:worked_days) { [2.weeks.ago.to_date.strftime("%d/%m/%Y") ] }

    let(:second_company) { create :company }
    let(:second_company_admin) { create(:admin_user, company_id: second_company.id) }

    let(:some_block_result) { "some block result"}
    
    it 'sends an email when user have more than 8 hours' do
      allow(ExtraHourCalculator).to receive(:call).and_return(worked_days)
      expect(NotificationMailer).to receive(:notify_admin_extra_hour).with(admin, active_user_with_hour, worked_days)
      ExtraHourNotificationService.call
    end

    it 'do not sends an email to a anothers company admin when user have more than 8 hours' do
      allow(ExtraHourCalculator).to receive(:call).and_return([])
      expect(NotificationMailer).not_to receive(:notify_admin_extra_hour).with(second_company_admin, active_user_with_hour, worked_days)
      ExtraHourNotificationService.call
    end

    it 'do not sends an email when user have 8 hours or less' do
      allow(ExtraHourCalculator).to receive(:call).and_return([])
      expect(NotificationMailer).not_to receive(:notify_admin_extra_hour).with(admin, active_user_without_hour, worked_days)
      ExtraHourNotificationService.call
    end

    it 'do not sends an email to inactive_user' do
      allow(ExtraHourCalculator).to receive(:call).and_return(worked_days)
      expect(NotificationMailer).not_to receive(:notify_admin_extra_hour).with(admin, inactive_user, worked_days)
      ExtraHourNotificationService.call
    end

  end
end
