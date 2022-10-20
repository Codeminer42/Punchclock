# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::PullRequestCollector, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    subject(:all) { described_class.new(client: client).all }

    let(:client) { class_double(Github) }

    context 'when there are no contributions in database' do
      it { is_expected.to be_empty }
    end

    context 'when there are contributions in database' do
      context 'when Github API is not able to respond' do
        let!(:contribution) { create(:contribution, :open_pr) }

        before do
          allow(client).to receive(:issues).and_raise('Connection error')
        end

        it 'returns empty' do
          expect(subject).to be_empty
        end
      end

      context 'when Pull Requests are fetched from GitHub API' do
        context 'when pr_state changed' do
          before do
            allow(client).to receive(:issues).and_return(pull_request_status)
          end

          let!(:contribution) { create(:contribution, :open_pr) }
          let(:response_body) do
            double(
              state: 'closed',
              pull_request: double({ merged_at: nil})
            )
          end
          let(:get) {double(body: response_body)}
          let(:pull_request_status) { double(get: get)}
          let(:expected_pr_collection) {{id: contribution.id, pr_state: 'closed'}}

          it 'returns contribution id and new PR State' do
            expect(subject).to include(expected_pr_collection)
          end
        end

        context 'when pr_state did not change' do
          before do
            allow(client).to receive(:issues).and_return(pull_request_status)
          end

          let!(:contribution) { create(:contribution, :open_pr) }
          let(:response_body) do
            double(
              state: 'open',
              pull_request: double({ merged_at: nil})
            )
          end
          let(:get) {double(body: response_body)}
          let(:pull_request_status) { double(get: get)}

          it 'returns empty' do
            expect(subject).to be_empty
          end
        end
      end
    end
  end
end
