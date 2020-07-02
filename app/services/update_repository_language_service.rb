class UpdateRepositoryLanguageService
  
  def perform
    repositories.each do |repository|
      result = Github::Repository.fetch_languages(repository.link)
      repository.update(language: result.languages) if result.success?
    end
  end

  private

  def repositories
    Repository.where(language: nil)
  end

end
