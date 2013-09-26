class CompanyController < InheritedResources::Base
	before_action :authenticate_user!
	load_and_authorize_resource

	def update
		if @company.update(company_params)
			flash.now[:notice] = "Company successful updated"
			redirect_to root_url
		else
			render action: :edit
		end
	end

private
	def company_params
		allow = [:name]
		params.require(:company).permit(allow)
	end
end
