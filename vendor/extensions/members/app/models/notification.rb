class Notification < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  belongs_to :from_member, :class_name => 'Member'
  belongs_to :to_member, :class_name => 'Member'
  
  default_scope :order => 'created_at desc'
  named_scope :seen, :conditions => 'seen = true'
  named_scope :unseen, :conditions => 'seen = false'
  named_scope :latest, :limit => 15
    
  def to_s 
    s = []
    s << from_member.company_name if from_member
    case notifiable_type 
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
end
