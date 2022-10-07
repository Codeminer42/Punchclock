require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::PullRequest do

  let!(:repository) { create(:repository) }
  let(:user) { create(:user) }
  let(:pr_state) { 'open' }
  let(:merged_at) { nil }
  let(:pull_request) { double(created_at: '2022-01-01',
                              html_url: "#{repository.link}/pull/1",
                              user: double(login: user.github),
                              state: pr_state,
                              pull_request: double(merged_at: merged_at)) }

  let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
  let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }

  subject { described_class.new(pull_request: pull_request, engineers: engineers_wrapper, repositories: repositories_wrapper) }

  describe '#pull_request_url' do
    it { expect(subject.pull_request_url).to eq "#{repository.link}/pull/1" }
  end

  describe '#repository_name' do
    it { expect(subject.repository_name).to eq repository.link.split('com/').last }
  end

  describe '#user_id' do
    it { expect(subject.user_id).to eq user.id }
  end

  describe '#repository_id' do
    it { expect(subject.repository_id).to eq repository.id }
  end

  describe '#created_at' do
    it { expect(subject.created_at).to eq '2022-01-01' }
  end

  describe '#pr_state' do
    context 'contribution state is open' do
      let(:pr_state) { 'open' }
      it { expect(subject.pr_state).to eq 'open' }
    end
    
    context 'contribution was closed but not merged' do
      let(:pr_state) { 'closed' }
      it { expect(subject.pr_state).to eq 'closed' }
    end

    context 'contribution was merged' do
      let(:pr_state) { 'closed' }
      let(:merged_at) { '2022-01-01' }
      it { expect(subject.pr_state).to eq 'merged' }
    end
  end
end
