class Notifier < ActionMailer::Base  
  helper :notifications
  default_url_options[:host] = "www.princetonmerchants.org"

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

  def new_member(member)
    subject "New member is pending"
    from "#{Radiant::Config['site.title']} <info@princetonmerchants.org>"
    recipients 'info@princetonmerchants.org, webmaster@princetonmerchants.org'
    sent_on Time.now
    body :member => member
  end

  def membership_denied(member)
    subject "Sorry, you were denied membership"
    from "#{Radiant::Config['site.title']} <info@princetonmerchants.org>"
    recipients member.email
    sent_on Time.now
    body :member => member
  end

  def account_activated(member)
    subject "Yay your account was activated"
    from "#{Radiant::Config['site.title']} <info@princetonmerchants.org>"
    recipients member.email
    sent_on Time.now
    body :member => member
  end

  def account_deactivated(member)
    subject "Uh oh, your account was deactivated"
    from "#{Radiant::Config['site.title']} <info@princetonmerchants.org>"
    recipients member.email
    sent_on Time.now
    body :member => member
  end
end