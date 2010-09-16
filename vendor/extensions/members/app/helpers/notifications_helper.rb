module NotificationsHelper
  def notifiable_path(notification) 
    if notification.notifiable_type == 'Page'
      notification.notifiable.url 
    else
      url_for notification.notifiable
    end
  end
end