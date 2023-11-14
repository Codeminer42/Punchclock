# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Create, type: :service do
  include EnvHelper
  include ActiveJob::TestHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end


  describe '#call' do
    subject(:call_create) { described_class.new(client: client).call }

    let(:client) { instance_double(Github::Client) }

    context 'when there are contributions to create' do
      let(:users) { create_list(:user, 2) }
      let(:repositories) { create_list(:repository, 2) }
      let!(:collected_contributions) do
        [
          instance_double(Github::Contributions::Wrappers::PullRequest,
            repository_id: repositories.first.id,
            pull_request_url: 'http://github.com/owner/repo/pull/123',
            created_at: Time.now,
            pr_state: 'open',
            contributors: users
          ),
          instance_double(Github::Contributions::Wrappers::PullRequest,
            repository_id: repositories.last.id,
            pull_request_url: 'http://github.com/owner/repo2/pull/456',
            created_at: Time.now,
            pr_state: 'closed',
            contributors: [users.first]
          )
        ]
      end

      before do
        allow_any_instance_of(Github::Contributions::Collect).to receive(:all).and_return(collected_contributions)
      end

      it 'creates contributions using find_or_create_by' do
        expect{ call_create }.to change(Contribution, :count).by 2     
      end

      it 'associates users with contributions' do
        call_create
        expect(Contribution.first.users).to eq(users)
        expect(Contribution.last.users).to eq([users.first])
      end

      it 'enqueues AlertFillContributionDescriptionJob for each user' do
        perform_enqueued_jobs do
          expect(AlertFillContributionDescriptionJob).to receive(:perform_later).with(users.first.id).once
          expect(AlertFillContributionDescriptionJob).to receive(:perform_later).with(users.last.id).once
          call_create
        end
      end
    end

    context 'when there are no contributions to create' do
      before do
        allow_any_instance_of(Github::Contributions::Collect).to receive(:all).and_return([])
      end

      it 'does not create any contributions' do
        expect{ call_create }.not_to change(Contribution, :count) 
      end

      it 'does not enqueue AlertFillContributionDescriptionJob' do
        perform_enqueued_jobs do
          expect(AlertFillContributionDescriptionJob).not_to receive(:perform_later)
          call_create
        end
      end
    end
  end
end
