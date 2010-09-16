class Member < ActiveRecord::Base
  belongs_to :category
  has_many :messages, :class_name => 'Message', :dependent => :destroy
  has_many :message_members
  has_many :messages_at, :class_name => 'Message', :source => :message, :through => :message_members
  has_many :responses, :class_name => 'MessageResponse', :foreign_key => 'member_id', :dependent => :destroy
  has_many :notifications, :foreign_key => 'to_member_id', :dependent => :destroy
  
  default_scope :order => 'company_name asc'
  named_scope :properties, :conditions => "level = 'Property'"
  named_scope :pending, :conditions => "status = 'pending'"
  named_scope :active, :conditions => "status = 'active'"
  named_scope :inactive, :conditions => "status = 'inactive'"
  named_scope :denied, :conditions => "status = 'denied'"
  named_scope :with_email, :conditions => "email is not null and email != ''"

  has_attached_file :logo, 
    :styles => { 
      :large => "350x350>", 
      :small => "275x150>", 
      :thumb => "50x50#", 
      :small_thumb => "35x35#",  
      :tiny => "16x16#" 
    },
    :whiny => false,
    :storage => Radiant::Config["assets.storage"] == "s3" ? :s3 : :filesystem, 
    :s3_credentials => {
      :access_key_id => Radiant::Config["assets.s3.key"],
      :secret_access_key => Radiant::Config["assets.s3.secret"]
    },
    :bucket => Radiant::Config["assets.s3.bucket"],
    :url => Radiant::Config["assets.url"] ? Radiant::Config["assets.url"] : "/:class/:id/:basename:no_original_style.:extension", 
    :path => Radiant::Config["assets.path"] ? Radiant::Config["assets.path"] : ":rails_root/public/:class/:id/:basename:no_original_style.:extension"

  attr_accessor :password, :password_confirmation

  cattr_accessor :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :domain_regex, :logo_delete
  
  self.email_name_regex = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  self.email_regex = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.domain_regex = /\A#{domain_head_regex}#{domain_tld_regex}.*\z/i
  
  validates_confirmation_of :password, :unless => Proc.new {|m| m.password.blank?}
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :email, :with => email_regex, :allow_blank => true
  
  validates_presence_of :company_name
  validates_uniqueness_of :company_name, :allow_blank => true
  validates_format_of :company_email, :billing_email, :with => email_regex, :allow_blank => true
  
  validates_uniqueness_of :website, :allow_blank => true
  validates_format_of :website, :with => domain_regex, :allow_blank => true
  
  validates_presence_of :category_id, :if => Proc.new {|m| m.category_other.blank?}
  
  validates_format_of :profile_name, :with => /[A-Za-z]+[a-z0-9]*/
  validates_length_of :profile_name, :minimum => 3
  validates_uniqueness_of :profile_name
  
  acts_as_authentic do |c|
    c.login_field = 'email'
    c.validate_login_field false
    c.validate_email_field false
    c.validate_password_field false
  end
  
  def deliver_password_reset_instructions!
    reset_persistence_token!
    Notifier.deliver_password_reset_instructions(self)
  end
      
  state_machine :status, :initial => :pending do
    event :activate do
      transition [:inactive, :pending, :active] => :active
    end
    event :deactivate do
      transition [:inactive, :pending, :active] => :inactive
    end
    event :deny do
      transition :pending => :denied
    end
    
    state :pending do 
      validates_presence_of :email, :name, :phone
    end
    state :denied
    state :active
    state :inactive
  end
  
  def claimed?
    true unless email.blank? and name.blank? and phone.blank? and crypted_password.blank?
  end
  
  def to_param
    normalized_company_name = company_name.to_s.strip.gsub(/[ \.\_\/\\]/, '-').gsub(/[^a-zA-Z0-9\-]/, '')
    "#{self.id}-#{normalized_company_name}"
  end
  
  def company_address
    s = company_address_1 
    s += " #{company_address_2}" unless company_address_2.blank?
    unless company_city.blank? and company_state.blank? and company_zip.blank?
      s += ", #{company_city}, #{company_state} #{company_zip}" 
    end
    s
  end
end
