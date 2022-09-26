
class RepositoryQuery
  module Scopes
    def filter_by_languages(langs)
      return self if langs.blank?

      condition = '^' + langs.map { |l| "(?=.*#{Regexp.escape(l)})" }.join + ".*$"

      where("language ~* ?", condition)
    end
  end

  def initialize(opts = {})
  	@scopes = Repository.all
    @opts = opts
  end

  def fetch
    @scopes
    .extending(Scopes)
    .filter_by_languages(@opts.fetch(:langs, []))
    .order(:link)
  end
end
