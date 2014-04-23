class NotificationController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = end_of_chain.unreads
    respond_with @notifications
  end

  def update
    @notification = end_of_chain.find(params[:id])
    @notification.update(notification_params)
    respond_with @notification, location: notification_index_path
  end

  private

  def end_of_chain
    current_user.notifications
  end

  def notification_params
    params.require(:notification).permit(:read)
  end
end
