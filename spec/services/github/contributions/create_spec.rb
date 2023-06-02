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
      let(:contributions) do
        [
          instance_double(Github::Contributions::Wrappers::PullRequest,
            user_id: 1,
            repository_id: 1,
            pull_request_url: 'http://github.com/owner/repo/pull/123',
            created_at: Time.now,
            pr_state: 'open'
          ),
          instance_double(Github::Contributions::Wrappers::PullRequest,
            user_id: 2,
            repository_id: 2,
            pull_request_url: 'http://github.com/owner/repo2/pull/456',
            created_at: Time.now,
            pr_state: 'closed'
          )
        ]
      end

      before do
        allow_any_instance_of(Github::Contributions::Collect).to receive(:all).and_return(contributions)
        allow(Contribution).to receive(:find_or_create_by).and_call_original
      end

      it 'creates contributions using find_or_create_by' do
        expect(Contribution).to receive(:find_or_create_by).twice
        call_create
      end

      it 'enqueues AlertFillContributionDescriptionJob for each user' do
        perform_enqueued_jobs do
          expect(AlertFillContributionDescriptionJob).to receive(:perform_later).with(1).once
          expect(AlertFillContributionDescriptionJob).to receive(:perform_later).with(2).once
          call_create
        end
      end
    end

    context 'when there are no contributions to create' do
      before do
        allow_any_instance_of(Github::Contributions::Collect).to receive(:all).and_return([])
      end

      it 'does not create any contributions' do
        expect(Contribution).not_to receive(:find_or_create_by)
        call_create
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
