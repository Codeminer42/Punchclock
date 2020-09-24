namespace :github do
  desc 'Fill the programming languages of the repositories'
  task repositories_languages: :environment do
    UpdateRepositoryLanguageService.new.perform
  end

  desc "Search and create miners contributions"
  task import_contributions: :environment do
    contributions = Github::SearchContribution.call

    ActiveRecord::Base.transaction do
      contributions.each do |contribution|
        CreateContributionService.new.call(
          user: contribution.profile,
          link: contribution.link
        )
      end
    end
  end  
end
