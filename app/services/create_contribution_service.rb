# frozen_string_literal: true

class CreateContributionService
  Result = Struct.new(:json, :status)

  def call(contribution_params)
    user = find_user(contribution_params[:user])

    if user.nil?
      return Result.new({ message: 'User not found' }, :not_found) 
    else
      contribution = user.company.contributions.new(user: user, link: contribution_params[:link])

      if contribution.save
        Result.new(contribution, :created) 
      else
        Result.new({ message: contribution.errors }, :unprocessable_entity)
      end
    end
  end

  private

  def find_user(github_user)
    User.find_by(github: github_user)
  end
end
