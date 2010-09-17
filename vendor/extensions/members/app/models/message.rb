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
  after_create :notify!
  
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
      unless at_member_id.blank? or at_member_id == member.id or not Member.exists?(at_member_id) or 
      message_members.collect(&:member_id).include?(at_member_id)
        message_members << MessageMember.new(:member_id => at_member_id, :at_wall => true)
      end
      body2 = body.split("\n").collect do |line|
        line.split(' ').collect do |word|
          if match_start = word =~ /@[A-Za-z]+[A-Za-z0-9]*/
            match_end = word.index(/[^A-Za-z0-9]/, match_start + 1)
            potential_profile_name = match_end ? word[match_start..match_end-1] : word[match_start..-1]
            if member2 = Member.find_by_profile_name(potential_profile_name[1..-1])
              unless message_members.collect(&:member_id).include?(member2.id) or member2.id == member.id
                message_members << MessageMember.new(:member_id => member2.id, :at_wall => false)
              end
              before = match_start > 0 ? word[0..match_start-1] : ''
              after = match_end ? word[match_end..-1] : ''
              %{#{before}<a href="/members-only/members/#{member2.to_param}">#{member2.company_name}</a>#{after}}
            else
              word 
            end
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
