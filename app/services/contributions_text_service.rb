class ContributionsTextService
  def self.call(collection)
    new(collection).call
  end

  def initialize(collection)
    @collection = collection
  end

  def call
    contributions = @collection.joins(user: :office).select('*').reorder('offices.id, users.id')

    generate_text(contributions)
  end


  def generate_text(contributions)
    number_of_contributions = contributions.size
    number_of_contributors = contributions.map(&:name).uniq.size

    text = <<~HEREDOC
      #{number_of_contributions} PR's de #{number_of_contributors} Miners \n
    HEREDOC
    contributions.group_by(&:city).map do |city, values|
      text += "## #{city}\n\n"
      text += create_contributions_text_for_office(values)
      text += "\n\n\n"
    end

    text
  end

  private

  def create_contributions_text_for_office(contributions)
    text_array = contributions
      .group_by(&:name)
      .map do |name, values|
        <<~HEREDOC
          # #{name} (@#{values[0].github})
          - #{values.map(&:link).join(" \n- ")}

        HEREDOC
      end
    text_array.reduce do |acc, values|
      acc += values
    end
  end
end
