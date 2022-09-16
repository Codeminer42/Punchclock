require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::PullRequest do

  let(:engineers) { double(active: double(pluck: [['github_user', 999]])) }
  let(:repositories) { double(pluck: [[1, 'https://github.com/owner/repo-name']]) }
  let(:users) { double(engineer: engineers) }
  let(:pull_request) { double(created_at: '2022-01-01', html_url: 'https://github.com/owner/repo-name/pulls/123', user: double(login: 'github_user')) }

  let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
  let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }

  subject { described_class.new(pull_request: pull_request, engineers: engineers_wrapper, repositories: repositories_wrapper) }

  describe '#pull_request_url' do
    it { expect(subject.pull_request_url).to eq 'https://github.com/owner/repo-name/pulls/123' }
  end

  describe '#repository_name' do
    it { expect(subject.repository_name).to eq 'owner/repo-name' }
  end

  describe '#user_id' do
    it { expect(subject.user_id).to eq 999 }
  end

  describe '#repository_id' do
    it { expect(subject.repository_id).to eq 1 }
  end

  describe '#created_at' do
    it { expect(subject.created_at).to eq '2022-01-01' }
  end
end
