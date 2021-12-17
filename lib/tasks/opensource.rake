namespace :opensource do
  desc 'Destroy repositories without contributions'
  task clean_up_repositories_with_no_contribs: :environment do
    Repository.left_outer_joins(:contributions).where(contributions: { id: nil }).destroy_all
  end
end
