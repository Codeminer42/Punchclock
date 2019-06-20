require 'rails_helper'

RSpec.describe SendEmailWithUnregisteredPunchesJob, type: :job do

  describe '#perform' do
    let(:company) { create :company, name: "Codeminer42" }
    let(:active_user) { create :user, company: company, active: true }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    let(:last_30_work_days) do
      ('2019-04-15'.to_date..'2019-05-14'.to_date).select { |day| day.on_weekday? && !day.holiday?(:br) }
    end

    before do
      travel_to Date.new(2019, 05, 18)
      allow(NotificationMailer).to receive(:notify_unregistered_punches).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_now)
    end

    after do
      travel_back
    end

    it 'is in default queue' do
      expect(SendEmailWithUnregisteredPunchesJob.new.queue_name).to eq('default')
    end

    context 'user with no punches registered' do
      let(:unregistered_punches) { last_30_work_days.map { |day| [day, 0] }.to_h }

      it 'executes perform' do
        expect(NotificationMailer).to receive(:notify_unregistered_punches).with(active_user, unregistered_punches)
        subject.perform
      end
    end

    context 'user with all punches registered' do
      let!(:registered_punches) do
        last_30_work_days.map do |day| 
          create_list :punch, 2, user: active_user, company: company, from: day.to_datetime, to: day.to_datetime 
        end
      end

      it 'executes perform' do
        expect(NotificationMailer).not_to receive(:notify_unregistered_punches)
        subject.perform
      end
    end

    context 'user with all punches of a day registered' do
      let!(:registered_punches) do
        create_list :punch, 2, user: active_user, company: company, 
        from: last_30_work_days.last, to: last_30_work_days.last
      end

      it 'executes perform' do
        expect(NotificationMailer).to receive(:notify_unregistered_punches).with(active_user, hash_excluding(last_30_work_days.last))
        subject.perform
      end
    end

    context 'user with only 1 punch of a day registered' do
      let!(:half_day_registered) do
        create :punch, user: active_user, company: company, 
        from: last_30_work_days.first, to: last_30_work_days.first
      end

      it 'executes perform' do
        expect(NotificationMailer).to receive(:notify_unregistered_punches).with(active_user, hash_including(last_30_work_days.first => 1))
        subject.perform
      end
    end
  end
end
