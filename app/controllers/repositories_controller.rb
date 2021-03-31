require('repository_query')

class RepositoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :query_params

  def index
    @repositories = RepositoryQuery.new(current_company, { langs: @languages })
      .fetch
      .page(@page)
      .decorate
  end

  private

  def query_params
    @languages = params[:languages] ? params[:languages].split(',') : nil
    @page = params[:page]
  end
end
