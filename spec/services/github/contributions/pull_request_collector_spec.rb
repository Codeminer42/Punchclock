# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::PullRequestCollector, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    let(:client) { class_double(Github) }

    subject { described_class.new(client: client) }

    context 'when there are no contributions in database' do
      it 'returns empty array' do
        expect(subject.all).to be_empty
      end
    end

    context 'when there are contributions in database' do
      context 'when Github API is not able to respond' do
        before do
          create(:contribution, :open_pr)
          allow(client).to receive(:issues).and_raise(Github::Error::GithubError)
        end

        it 'returns empty' do
          expect(subject.all).to be_empty
        end
      end

      context 'when Pull Requests are fetched from GitHub API' do
        context 'when pr_state changed' do
          let!(:contribution) { create(:contribution, :open_pr) }
          let(:response_body) do
            double(
              state: 'closed',
              pull_request: double(merged_at: nil)
            )
          end
          let(:expected_pr_collection) { { id: contribution.id, pr_state: 'closed' } }

          before do
            create(:contribution, :merged_pr)
            create(:contribution, :closed_pr)

            allow(client).to receive_message_chain(:issues, :get, :body) { response_body }
          end

          it 'returns contribution id and new PR State' do
            expect(subject.all).to contain_exactly(expected_pr_collection)
          end
        end

        context 'when pr_state did not change' do
          let!(:contribution) { create(:contribution, :open_pr) }
          let(:response_body) do
            double(
              state: 'open',
              pull_request: double(merged_at: nil)
            )
          end

          before do
            allow(client).to receive_message_chain(:issues, :get, :body) { response_body }
          end

          it 'returns empty' do
            expect(subject.all).to be_empty
          end
        end
      end
    end
  end
end
