class MessageMember < ActiveRecord::Base
  belongs_to :member
  belongs_to :message
  acts_as_list :scope => :message
end
