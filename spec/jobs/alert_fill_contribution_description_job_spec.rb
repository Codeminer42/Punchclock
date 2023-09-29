require 'rails_helper'

RSpec.describe AlertFillContributionDescriptionJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user) }

    context "when user has received contributions" do
      let(:contributions) { create_list(:contribution, 3, user: user) }
      # TODO
      it "sends a notification email when user has received contributions" do
        expect(NotificationMailer).to receive(:notify_fill_contribution_description).with(user, contributions.length).and_return(double(deliver_later: true))

        perform_enqueued_jobs do
          described_class.perform_later(user.id)
        end

        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context "when user has no received contributions" do
      let(:user) { create(:user) }
      let(:contributions) { create_list(:contribution, 3, :approved, user: user) }
      it "does not send a notification email when user has no received contributions" do
        expect(NotificationMailer).not_to receive(:notify_fill_contribution_description)

        perform_enqueued_jobs do
          described_class.perform_later(user.id)
        end

        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end

