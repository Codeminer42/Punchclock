# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Collect, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    subject(:all) { described_class.new(client: client).all }

    let(:client) { class_double(Github) }

    context 'when there are no repositories in database' do
      it { is_expected.to be_empty }
    end

    context 'when there are no engineers in database' do
      it { is_expected.to be_empty }
    end

    context 'when Github API is not able to respond' do
      let(:repositories) { double(pluck: [[1, 'http://example.com']]) }
      let(:engineers) { double(active: double(pluck: [['github_user', 1]])) }
      let(:users) { double(engineer: engineers) }

      before do
        allow(client).to receive(:search) { raise 'any error' }
      end

      it { is_expected.to be_empty }
    end

    context 'when Pull Requests are fetched from GitHub API' do
      let!(:repository) { create(:repository) }
      let!(:user) { create(:user) }
      let(:pull_requests) { double(items: [ double(created_at: '2022-01-01', html_url: 'http://github.com/owner/name/pull/123', user: double(login: 'github_user')) ]) }
      let(:client_search) { double(issues: pull_requests) }

      before do
        allow(client).to receive(:search).and_return(client_search)
      end

      it { is_expected.not_to be_empty }

      it 'returns the found pull requests wrapped into the PullRequest Wrapper' do
        expect(subject[0]).to be_instance_of(Github::Contributions::Wrappers::PullRequest)
      end
    end
  end
end
