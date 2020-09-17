# frozen_string_literal: true

class SearchContributionService
  def initialize
    @github = Github.new oauth_token: ENV['GITHUB_TOKEN']
  end

  attr_reader :github

  def perform
    Repository.all.each do |repo|
      list = list_pull_request(repo)
      find_prs_miners(list)
    end
  end

  private

  def list_pull_request(repo)
    repo_owner = repo.link.split('/')[3]
    repo_name = repo.link.split('/').last
    github.pull_requests.list repo_owner, repo_name
  end

  def find_prs_miners(list)
    User.engineer.active.each do |miner|
      results = list.body.select { |k| k.user.login == miner.github }
      create_contribution(results, miner.github) if results.present?
    end
  end

  def create_contribution(results, miner_git)
    results.each do |result|
      link = result._links.html.href
      CreateContributionService.new.call(user: miner_git, link: link)
    end
  end
end
