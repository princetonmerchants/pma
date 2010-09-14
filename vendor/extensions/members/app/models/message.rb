class Message < ActiveRecord::Base
  belongs_to :member
  has_many :message_members, :dependent => :destroy, :order => 'position asc', :uniq => true
  has_many :at_members, :class_name => 'Member', :source => :member, :through => :message_members
  has_many :at_member_walls, :class_name => 'Member', :source => :member, :through => :message_members, 
    :conditions => 'at_wall = true'
  has_many :responses, :class_name => 'MessageResponse', :foreign_key => 'message_id', :dependent => :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  attr_accessor :at_member_id
  
  before_save :apply_at_members
  after_save :notify!
  
  default_scope :order => 'messages.created_at desc'
  named_scope :recent, :include => :at_members
  named_scope :wall, lambda {|member_id| {
      :conditions => ['messages.member_id = ? or ' +
        'exists (select 1 from message_members mm where mm.message_id = messages.id and mm.member_id = ?) or ' +
        'exists (select 1 from message_responses mr where mr.message_id = messages.id and mr.member_id = ?) ', 
        member_id, member_id, member_id], 
      :include => [:at_members, :responses]
    }}
    
  def seen_by!(member_id)
    notifications.update_all 'seen = true', "to_member_id = #{member_id}"
    responses.each {|r| r.notifications.update_all 'seen = true', "to_member_id = #{member_id}"}
  end
    
  private
  
    def apply_at_members
      unless at_member_id.blank? or at_member_id == member.id or not Member.exists?(at_member_id)
        message_members << MessageMember.new(:member_id => at_member_id, :at_wall => true)
      end
      body2 = body.split("\n").collect do |line|
        line.split(' ').collect do |word|
          if word[0] == 64 and (member2 = Member.find_by_profile_name(word[1..-1].strip)) and member2.id != member.id
            at_members << member2
            %{"#{member2.profile_name}":/members-only/members/#{member2.to_param}}
          else
            word
          end
        end.join(' ')
      end.join("\n")
      write_attribute :body, body2 
    end
    
    def notify!
      at_members.each do |at_member|
        notifications.create :from_member_id => member.id, :to_member_id => at_member.id
      end
    end
end
