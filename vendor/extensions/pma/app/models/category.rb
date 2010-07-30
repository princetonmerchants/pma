class Category < ActiveRecord::Base
  has_many :member_categories
  has_many :members, :through => :member_categories
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
