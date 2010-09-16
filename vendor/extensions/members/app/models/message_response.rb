class MessageResponse < ActiveRecord::Base
  belongs_to :member
  belongs_to :message
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  after_create :notify!
  
  private
    
    def notify!
      message.responses.collect(&:member).each do |at_member|
        notifications.create :from_member_id => member.id, :to_member_id => at_member.id unless member.id == at_member.id
      end
      notifications.create :from_member_id => member.id, :to_member_id => message.member.id unless member.id == message.member.id
    end
end
