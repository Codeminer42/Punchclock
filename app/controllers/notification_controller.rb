class NotificationController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @notifications = current_user.notifications.where("read IS NULL")
  end

  def update
    @notification.update(notification_params)
    render action: :index
  end

  private
  def notification_params
    params.require(:notification).permit(:read)
  end
end
