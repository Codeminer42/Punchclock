require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::PullRequest do
  describe '#pull_request_url' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.pull_request_url).to eq "#{repository.link}/pull/1" }
  end

  describe '#repository_name' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.repository_name).to eq repository.link.split('com/').last }
  end

  describe '#user_id' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.user_id).to eq user.id }
  end

  describe '#repository_id' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.repository_id).to eq repository.id }
  end

  describe '#created_at' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.created_at).to eq '2022-01-01' }
  end

  describe '#pr_state' do
    context 'contribution state is open' do
      let(:pr_state) { 'open' }
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end

      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end

      it { expect(subject.pr_state).to eq 'open' }
    end

    context 'contribution was closed but not merged' do
      let(:pr_state) { 'closed' }
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end

      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end

      it { expect(subject.pr_state).to eq 'closed' }
    end

    context 'contribution was merged' do
      let(:pr_state) { 'closed' }
      let(:merged_at) { '2022-01-01' }
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end

      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end

      it { expect(subject.pr_state).to eq 'merged' }
    end
  end

  describe '#repository_owner' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.repository_owner).to eq 'Codeminer42' }
  end

  describe '#pull_request_number' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    it { expect(subject.pull_request_number).to eq '1' }
  end

  describe '#pull_request_commits' do
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:co_author) { build(:user, github: 'username42') }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    let(:commit) do
      {
        'committer' => {
          'login' => user.github
        },
        'commit' => {
          'message' => "add some cool feature.\n\n Co-authored-by: #{co_author.github} <#{co_author.github}@email.com>"
        }
      }
    end

    let(:github_client_mock) do
      instance_double(Github::Client::PullRequests, commits: { commit: })
    end

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    before { allow(Github::Client::PullRequests).to receive(:new).and_return(github_client_mock) }

    it { expect(subject.pull_request_commits).to eq(commit:) }
  end

  describe '#get_co_authors_data_by_commit_messages' do
    context 'when there are co-authors specified on commit messages through their usernames' do
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:co_author) { build(:user, github: 'username42') }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:commits) do
        [
          {
            'commit' => {
              'message' => "add some cool feature.\n\nCo-authored-by: #{co_author.github} <#{co_author.email}>"
            }
          }
        ]
      end
  
  
      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before { allow(subject).to receive(:pull_request_commits).and_return(commits) }

      it 'returns a set containing co-authors data' do 
          expect(subject.get_co_authors_data_by_commit_messages)
          .to include([co_author.github, co_author.email])
          .and be_instance_of(Set)
      end
    end

    context 'when there are co-authors specified on commit messages through their names' do
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:co_author) { build(:user, github: 'username42') }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:commits) do
        [
          {
            'commit' => {
              'message' => "add some cool feature.\n\nCo-authored-by: #{co_author.name} <#{co_author.email}>"
            }
          }
        ]
      end
  
  
      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before { allow(subject).to receive(:pull_request_commits).and_return(commits) }

      it 'returns a set containing co-authors data' do 
          expect(subject.get_co_authors_data_by_commit_messages)
          .to include([co_author.name, co_author.email])
          .and be_instance_of(Set)
      end
    end

    context 'when there are no co-authors specified on commit messages' do
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:commits) do
        [
          {
            'commit' => {
              'message' => "add some cool feature."
            }
          }
        ]
      end     

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before { allow(subject).to receive(:pull_request_commits).and_return(commits) }

      it 'returns an empty set' do 
          expect(subject.get_co_authors_data_by_commit_messages)
          .to be_empty
          .and be_instance_of(Set)
      end
    end
  end

  describe '#get_co_authors_data_by_committers' do 
    context 'when committer is not the author' do
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:co_author) { build(:user, github: 'username42') }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:commits) do
        [
          {
            'committer' => {
              'login' => co_author.github
            }
          }
        ]
      end
  
  
      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before { allow(subject).to receive(:pull_request_commits).and_return(commits) }

      it 'considers the committer as a co author' do 
          expect(subject.get_co_authors_data_by_committers)
          .to include(co_author.github)
          .and be_instance_of(Set)
      end
    end

    context 'when committer is the author' do
      let!(:repository) { create(:repository) }
      let(:user) { create(:user) }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:commits) do
        [
          {
            'committer' => {
              'login' => user.github
            }
          }
        ]
      end
  
  
      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before { allow(subject).to receive(:pull_request_commits).and_return(commits) }

      it 'does not consider the committer as a co author' do 
          expect(subject.get_co_authors_data_by_committers)
          .to include(nil)
          .and be_instance_of(Set)
      end
    end
  end

  describe '#co_authors_ids_by_messages' do 
    context 'when there is an existent co-author with the username specified on commit message' do
      let!(:repository) { create(:repository) }
      let!(:user) { create(:user) }
      let!(:co_author) { create(:user, github: 'username42') }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:co_author_data) { [[co_author.github, co_author.email]] }
  
      let(:commits) do
        [
          {
            'commit' => {
              'message' => "add some cool feature.\n\nCo-authored-by: #{co_author.github} <#{co_author.email}>"
            }
          }
        ]
      end

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before do 
        allow(subject).to receive(:get_co_authors_data_by_commit_messages).and_return(co_author_data)
      end

      it 'considers the committer as a co author' do
          expect(subject.co_authors_ids_by_messages)
          .to eq([co_author.id])
      end
    end

    context 'when there is an existent co-author with the email specified on commit message' do
      let!(:repository) { create(:repository) }
      let!(:user) { create(:user) }
      let!(:co_author) { create(:user, github: 'username42') }
      let(:pr_state) { 'open' }
      let(:merged_at) { nil }
      let(:pull_request) do
        double(created_at: '2022-01-01',
               html_url: "#{repository.link}/pull/1",
               user: double(login: user.github),
               state: pr_state,
               pull_request: double(merged_at:))
      end
  
      let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
      let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
      let(:github_client) { Github::Client.new }
  
      let(:co_author_data) { [[co_author.name, co_author.email]] }
  
      let(:commits) do
        [
          {
            'commit' => {
              'message' => "add some cool feature.\n\nCo-authored-by: #{co_author.name} <#{co_author.email}>"
            }
          }
        ]
      end

      subject do
        described_class.new(pull_request:,
                            engineers: engineers_wrapper,
                            repositories: repositories_wrapper,
                            client: github_client)
      end
  
      before do 
        allow(subject).to receive(:get_co_authors_data_by_commit_messages).and_return(co_author_data)
      end

      it 'considers the committer as a co author' do
          expect(subject.co_authors_ids_by_messages)
          .to eq([co_author.id])
      end
    end
  end

  describe '#co_authors_ids_by_committers' do 
    let!(:repository) { create(:repository) }
    let(:user) { create(:user) }
    let(:co_author) { create(:user, github: 'username42') }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }
    
    let(:co_author_data) { [co_author.github] }
    let(:commit) do
      {
        'committer' => {
          'login' => co_author.github
        }
      }
    end

    let(:github_client_mock) do
      instance_double(Github::Client::PullRequests, commits: { commit: })
    end


    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    before { allow(subject).to receive(:get_co_authors_data_by_committers).and_return(co_author_data) }

    it { expect(subject.co_authors_ids_by_committers).to eq [co_author.id] }
  end

  describe '#co_authors' do
    let!(:repository) { create(:repository) }
    let!(:user) { create(:user) }
    let(:co_author) { create(:user, github: 'username42') }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end
    let(:co_authors_logins) { [co_author.id] }

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    before do 
      allow(subject).to receive(:co_authors_ids_by_committers).and_return(co_authors_logins)
      allow(subject).to receive(:co_authors_ids_by_messages).and_return(co_authors_logins)
    end

    it { expect(subject.co_authors).to eq [co_author.id] }
  end

  describe '#contributors_ids' do 
    let!(:repository) { create(:repository) }
    let!(:user) { create(:user) }
    let(:co_author) { create(:user, github: 'username42') }
    let(:pr_state) { 'open' }
    let(:merged_at) { nil }
    let(:pull_request) do
      double(created_at: '2022-01-01',
             html_url: "#{repository.link}/pull/1",
             user: double(login: user.github),
             state: pr_state,
             pull_request: double(merged_at:))
    end

    let(:engineers_wrapper) { Github::Contributions::Wrappers::Engineers.new }
    let(:repositories_wrapper) { Github::Contributions::Wrappers::Repositories.new }
    let(:github_client) { Github::Client.new }

    subject do
      described_class.new(pull_request:,
                          engineers: engineers_wrapper,
                          repositories: repositories_wrapper,
                          client: github_client)
    end

    before do 
      allow(subject).to receive(:co_authors).and_return([co_author.id])
    end

    it { expect(subject.contributors_ids).to eq [co_author.id, user.id ] }
  end
end
