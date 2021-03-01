
class RepositoryQuery
  module Scopes
    def filter_by_languages(langs)
      return self if langs.blank?
  
      condition = '^' + langs.map { |l| "(?=.*\\m#{l}\\M)" }.join + ".*$"
  
      where("language ~* ?", condition)
    end
  end

  def initialize(scope, opts = {})
  	@scopes = scope.repositories
    @opts = opts
  end

  def fetch
    @scopes
    .extending(Scopes)
    .filter_by_languages(@opts.fetch(:langs, []))
    .order(:link)
  end
end
