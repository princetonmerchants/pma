class MemberCategory < ActiveRecord::Base
  belongs_to :member
  belongs_to :category
end
