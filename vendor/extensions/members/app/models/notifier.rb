class Notifier < ActionMailer::Base
  default_url_options[:host] = Radiant::Config['site.url']
  
  def password_reset_instructions(member)
    subject "Password Reset Instructions"
    from "#{Radiant::Config['site.title']} <#{Radiant::Config['site.no_reply_email']}>"
    recipients member.email
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(member.persistence_token)
  end
  
  def new_notification(notification)
    subject notification
    from "#{Radiant::Config['site.title']} <#{Radiant::Config['site.no_reply_email']}>"
    recipients notification.to_member.email
    sent_on Time.now
    body :notification => notification
  end
end