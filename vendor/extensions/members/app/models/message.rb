class Message < ActiveRecord::Base
  belongs_to :member
  has_many :message_members, :dependent => :destroy, :order => 'position asc'
  has_many :at_members, :class_name => 'Member', :source => :member, :through => :message_members
  has_many :responses, :class_name => 'MessageResponse', :foreign_key => 'message_id', :dependent => :destroy
  
  attr_accessor :at_member_id
  
  before_save :apply_at_members
  
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
  
    def apply_at_members
      at_members << Member.find(at_member_id) unless at_member_id.blank?
      body2 = body.split(' ').collect do |word|
        if word[0] == 64 and (member = Member.find_by_profile_name(word[1..-1].strip))
          at_members << member 
          %{"#{member.profile_name}":/members-only/members/#{member.to_param}}
        else
          word
        end
      end.join(' ')
      write_attribute :body, body2 
    end
end
