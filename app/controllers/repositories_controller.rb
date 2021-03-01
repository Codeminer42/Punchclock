require('repository_query')

class RepositoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :query_params

  def index
    @repositories = RepositoryQuery.new(current_company, { langs: @languages })
      .fetch
      .decorate
  end

  private

  def query_params
    @languages = params[:languages] ? params[:languages].split(',') : nil
  end
end
