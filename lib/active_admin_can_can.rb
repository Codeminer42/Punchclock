module ActiveAdminCanCan
  def active_admin_collection
    super.accessible_by current_ability
  end

  def resource
    resource = super
    authorize! permission, resource
    resource
  end

  private

  def permission
    case action_name
    when "show"
      :read
    when "new", "create"
      :create
    when "edit"
      :update
    else
      action_name.to_sym
    end
  end
end