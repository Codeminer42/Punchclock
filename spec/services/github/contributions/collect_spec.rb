# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Collect, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    subject(:all) { described_class.new(company: company, client: client).all }

    let(:client) { class_double(Github) }
    let(:company) { build_stubbed(:company) }

    context 'when company is not present' do
      let(:company) { nil }

      it { is_expected.to be_empty }
    end

    context 'when there are no repositories in database' do
      it { is_expected.to be_empty }
    end

    context 'when there are no engineers in database' do
      let(:repositories) { double(pluck: [[1, 'http://example.com']]) }

      before do
        allow(company).to receive(:repositories).and_return(repositories)
      end
      
      it { is_expected.to be_empty }
    end

    context 'when Github API is not able to respond' do
      let(:repositories) { double(pluck: [[1, 'http://example.com']]) }
      let(:engineers) { double(active: double(pluck: [['github_user', 1]])) }
      let(:users) { double(engineer: engineers) }

      before do
        allow(company).to receive(:repositories).and_return(repositories)
        allow(company).to receive(:users).and_return(users)
        allow(client).to receive(:search) { raise 'any error' }
      end

      it { is_expected.to be_empty }
    end

    context 'when Pull Requests are fetched from GitHub API' do
      let(:repositories) { double(pluck: [[293, 'http://github.com/owner/name']]) }
      let(:engineers) { double(active: double(pluck: [['github_user', 100]])) }
      let(:users) { double(engineer: engineers) }
      let(:pull_requests) { double(items: [ double(created_at: '2022-01-01', html_url: 'http://github.com/owner/name/pull/123', user: double(login: 'github_user')) ]) }
      let(:client_search) { double(issues: pull_requests) }

      before do
        allow(company).to receive(:repositories).and_return(repositories)
        allow(company).to receive(:users).and_return(users)
        allow(client).to receive(:search).and_return(client_search)
      end

      it { expect(subject[0].pull_request_url).to eq 'http://github.com/owner/name/pull/123' }

      it { expect(subject[0].repository_id).to eq 293 }

      it { expect(subject[0].user_id).to eq 100 }
    end
  end
end
