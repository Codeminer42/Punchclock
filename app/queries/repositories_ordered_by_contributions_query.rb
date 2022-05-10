class RepositoriesOrderedByContributionsQuery
  def call
    repositories_query = <<-SQL
      SELECT r.id, r.link FROM repositories r
        ORDER BY (
          SELECT count(*)
          FROM contributions c
          WHERE r.id = c.repository_id
        ) DESC
    SQL

    repositories_rank = ActiveRecord::Base.connection.execute(repositories_query)
    repositories_rank.map { |repository| [repository['link'], repository['id']] }
  end
end
