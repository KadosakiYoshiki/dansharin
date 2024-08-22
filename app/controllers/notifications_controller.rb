class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    ActiveRecord::Base.transaction do
      @notification.update(read: true)
    end
    render turbo_stream: [
      turbo_stream.update("currentNotificationCount", partial: "notifications/notification_count", locals: { count: current_user.notifications.unread.count })
    ]
  end
end
