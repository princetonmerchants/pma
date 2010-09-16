class Notification < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  belongs_to :from_member, :class_name => 'Member'
  belongs_to :to_member, :class_name => 'Member'
  
  default_scope :order => 'created_at desc'
  named_scope :seen, :conditions => 'seen = true'
  named_scope :unseen, :conditions => 'seen = false'
  named_scope :latest, :limit => 15
  named_scope :undelivered, :conditions => 'email_delivered_at is null'
  named_scope :delivered, :conditions => 'delivered_at is not null'
  named_scope :since, lambda {|ago| {:conditions => ['created_at >= ?', ago]}}
  named_scope :range, lambda {|from, to| {:conditions => ['created_at between ? and ?', from, to]}}
  
  after_create :deliver_email!
    
  def to_s 
    s = []
    if from_member
      s << from_member.company_name 
    else
      s << 'The PMA'
    end
    case notifiable_type 
      when 'Page' then
        parent_titles = notifiable.ancestors.collect(&:title)
        if parent_titles.include?('News')
          s << 'posted an article.'
        elsif parent_titles.include?('Events')
          s << 'posted a featured event.'
        elsif parent_titles.include?('Resources')
          s << 'posted a resource.'
        end
      when 'Message' then 
        if notifiable.at_member_walls.include?(to_member)
          s << 'posted on your wall.'
        else
          s << 'wrote about you.'
        end
      when 'MessageResponse' then 
        if notifiable.message.member == to_member
          s << 'responded to your post.' 
        elsif notifiable.message.member == from_member
          s << 'responded to their own post.' 
        else
          s << "also responded to #{notifiable.message.member.company_name}'s post." 
        end
      else s << '...'
    end
    s.join(' ')
  end
  
  def at_members
    case notifiable_type 
      when 'Message' then notifiable.at_members
      when 'MessageResponse' then notifiable.message.responses.collect(&:member) << notifiable.message.member
    end
  end
  
  class << self
    def group_and_deliver_delayed!
      groups = Notification.undelivered.unseen.find(:all, 
        :select => 'notifiable_type, notifiable_id, from_member_id, -1 as created_at',
        :group => 'notifiable_type, notifiable_id, from_member_id')
      groups.collect do |group|
        notifications = group.notifiable.notifications.undelivered.unseen.range(1.week.ago, 3.hours.ago)
        recipients = notifications.collect(&:to_member).select do |member|
          case group.notifiable_type
            when 'Page' then
              parent_titles = group.notifiable.ancestors.collect(&:title)
              if parent_titles.include?('News')
                # posted an article.
                member.notify_me_when_articles_are_posted?
              elsif parent_titles.include?('Events')
                # posted a featured event.
                member.notify_me_when_featured_events_are_posted?
              elsif parent_titles.include?('Resources')
                # posted a resource.
                member.notify_me_when_resources_are_posted?
              end
            when 'Message' then 
              if notifiable.at_member_walls.include?(to_member)
                # posted on your wall.
                member.notify_me_when_others_post_on_my_wall?
              else
                # wrote about you.
                member.notify_me_when_others_post_on_my_wall?
              end
            when 'MessageResponse' then 
              if notifiable.message.member == to_member
                # responded to your post. 
                member.notify_me_when_others_respond?
              elsif notifiable.message.member == from_member
                # responded to their own post. 
                member.notify_me_when_others_respond?
              else
                # also responded to [member's] post.
                member.notify_me_when_others_respond?
              end
            else true
          end
        end.collect(&:email).select {|e| ! e.blank?}
        if notifications.empty?
          %{Group #{group.notifiable_type}-#{group.notifiable_id} not ready to send.}
        else
          Notifier.deliver_new_notification!(notifications.first, recipients)
          group.notifiable.notifications.undelivered.unseen.range(1.week.ago, 3.hours.ago).update_all :email_delivered_at => Time.now
          %{Group #{group.notifiable_type}-#{group.notifiable_id} sent to #{notifications.length} members.}
        end
      end
    end
  end
  
  private 
  
    def deliver_email!
      return if to_member.email.blank?
      case notifiable_type 
        when 'Page' then
          parent_titles = notifiable.ancestors.collect(&:title)
          if parent_titles.include?('News')
            # posted an article.
            # do nothing, delayed; if to_member.notify_me_when_articles_are_posted?
          elsif parent_titles.include?('Events')
            # posted a featured event.
            # do nothing, delayed; if to_member.notify_me_when_featured_events_are_posted?
          elsif parent_titles.include?('Resources')
            # posted a resource.
            # do nothing, delayed; if to_member.notify_me_when_resources_are_posted?
          end
        when 'Message' then 
          if notifiable.at_member_walls.include?(to_member)
            # posted on your wall.
            deliver_email_helper! if to_member.notify_me_when_others_post_on_my_wall?
          else
            # wrote about you.
            deliver_email_helper! if to_member.notify_me_when_others_post_on_my_wall?
          end
        when 'MessageResponse' then 
          if notifiable.message.member == to_member
            # responded to your post. 
            deliver_email_helper! if to_member.notify_me_when_others_respond?
          elsif notifiable.message.member == from_member
            # responded to their own post. 
            deliver_email_helper! if to_member.notify_me_when_others_respond?
          else
            # also responded to [member's] post.
            deliver_email_helper! if to_member.notify_me_when_others_respond?
          end
        else s << '...'
      end
    end
    
    def deliver_email_helper!
      Notifier.deliver_new_notification!(self) 
      update_attribute :email_delivered_at, Time.now
    end
end
