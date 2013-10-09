class NotificationController < InheritedResources::Base
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @notifications = current_user.notifications
  end
end
