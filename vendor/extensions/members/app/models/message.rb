class Message < ActiveRecord::Base
  belongs_to :member
  has_many :message_members
  has_many :at_members, :class_name => 'Member', :source => :member, :through => :message_members
  has_many :responses, :class_name => 'MessageResponse', :foreign_key => 'message_id'
  
  attr_accessor :at_member_id
  
  before_save :set_members_at
  
  default_scope :order => 'messages.created_at desc'
  named_scope :recent, :order => 'created_at desc', :include => :at_members
  named_scope :wall, lambda {|member_id| {
      :conditions => ['messages.member_id = ? or ' +
        'exists (select 1 from message_members mm where mm.message_id = messages.id and mm.member_id = ?) or ' +
        'exists (select 1 from message_responses mr where mr.message_id = messages.id and mr.member_id = ?) ', 
        member_id, member_id, member_id], 
      :include => [:at_members, :responses]
    }}
    
  private
  
    def set_members_at
      at_members << Member.find(at_member_id) unless at_member_id.blank?
    end
end
