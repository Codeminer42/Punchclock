class NotificationController < ApplicationController
  before_action :authenticate_user!
  self.responder = FastResponder

  def index
    @notifications = current_user.notifications.where read: nil
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.update(notification_params)
    respond_with @notification
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end
end
