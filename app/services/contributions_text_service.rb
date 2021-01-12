class ContributionsTextService
  def initialize(contributions)
    @contributions = contributions.joins(user: :office).select("*").reorder("offices.id, users.id")
    @filtered_data = filter_data
    @text = ""
    @miners = 0
    @prs = 0
  end

  def generate
    generate_text
    @text
  end

  private

  def generate_text
    @filtered_data.each_with_index do |contribution,index|
      if index == 0
        add_office_contribution contribution
      elsif @filtered_data[index - 1][:city] != contribution[:city]
        add_office_contribution contribution, padding: true
      elsif @filtered_data[index - 1][:github] != contribution[:github]
        add_miner_contribution contribution
      else
        add_contribution contribution
      end
    end
    add_header
  end

  def add_contribution(contribution)
    @text +=  "- #{contribution[:link]}\n"
    @prs += 1
  end

  def add_miner_contribution(contribution)
    @text +=  "\n## #{contribution[:name]} (@#{contribution[:github]})\n"
    add_contribution contribution
    @miners += 1
  end

  def add_office_contribution(contribution,padding: false)
    @text += "\n\n\n" if padding
    @text +=  "# #{contribution[:city]}\n"
    add_miner_contribution contribution
  end

  def add_header
    miners_text = @miners != 1 ? "#{@miners} miners" : "#{@miners} miner"
    prs_text = @prs != 1 ? "#{@prs} PR's" : "#{@prs} PR"
    header_text = prs_text + " de " + miners_text + "\n\n"
    @text = header_text + @text

  end

  def filter_data
    filtered_data = []
    @contributions.each do |contribution|
      data = Hash.new
      data[:city] = contribution.city
      data[:name] = contribution.name
      data[:github] = contribution.github
      data[:link] = contribution.link
      filtered_data.append(data)
    end
    filtered_data
  end
end
