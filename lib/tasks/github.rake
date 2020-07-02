namespace :github do
  desc 'Fill the programming languages of the repositories'
  task repositories_languages: :environment do
    UpdateRepositoryLanguageService.new.perform
  end
end
