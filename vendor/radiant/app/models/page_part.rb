class PagePart < ActiveRecord::Base
  
  # Default Order
  default_scope :order => 'name'
  
  # Associations
  belongs_to :page
  
  # Validations
  validates_presence_of :name
  validates_length_of :name, :maximum => 100
  validates_length_of :filter_id, :maximum => 25, :allow_nil => true
  validates_numericality_of :id, :page_id, :allow_nil => true, :only_integer => true
  
  object_id_attr :filter, TextFilter

  def after_initialize
    self.filter_id ||= Radiant::Config['defaults.page.filter'] if new_record?
  end

end
