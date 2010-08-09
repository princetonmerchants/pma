class Category < ActiveRecord::Base
  has_many :members
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  default_scope :order => 'name asc'
  named_scope :non_empty, :conditions => 'exists (select 1 from members where category_id = categories.id)'
  
  def to_param
    normalized_name = name.to_s.strip.gsub(/[ \.\_\/\\]/, '-').gsub(/[^a-zA-Z0-9\-]/, '')
    "#{self.id}-#{normalized_name}"
  end
end
