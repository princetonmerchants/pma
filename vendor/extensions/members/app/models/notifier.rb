class Notifier < ActionMailer::Base  
  helper :notifications

  def password_reset_instructions(member)
    subject "Password Reset Instructions"
    from "#{Radiant::Config['site.title']} <#{Radiant::Config['site.no_reply_email']}>"
    recipients member.email
    sent_on Time.now
    body :edit_password_reset_url => edit_password_reset_url(member.persistence_token)
  end
  
  def new_notification(notification, grouped_recipients=nil)
    subject notification
    from "#{Radiant::Config['site.title']} <#{Radiant::Config['site.no_reply_email']}>"
    recipients "#{Radiant::Config['site.title']} <#{Radiant::Config['site.no_reply_email']}>"
    bcc (grouped_recipients || notification.to_member.email)
    sent_on Time.now
    body :notification => notification
  end
end