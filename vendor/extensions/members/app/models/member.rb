require "digest/sha1"

class Member < ActiveRecord::Base
  belongs_to :category
  
  before_save :hash_password_unless_empty
  
  default_scope :order => 'name asc'
  named_scope :properties, :conditions => "level = 'Property'"
  
  cattr_accessor :salt
  @@salt = 'pma4princeton'

  has_attached_file :logo, 
    :styles => { 
      :large => "350x350>", 
      :small => "250x250>", 
      :thumb2 => "100x100#", 
      :thumb => "100x100>", 
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

  cattr_accessor :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :domain_regex, :logo_delete
  
  self.email_name_regex = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  self.email_regex = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.domain_regex = /\A#{domain_head_regex}#{domain_tld_regex}\z/i
  
  #validates_presence_of :admin_email, :billing_email
  validates_uniqueness_of :admin_email, :billing_email, :allow_blank => true
  validates_format_of :admin_email, :billing_email, :with => email_regex, :allow_blank => true
  
  validates_uniqueness_of :website, :allow_blank => true
  validates_format_of :website, :with => domain_regex, :allow_blank => true

  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :category_id, :if => Proc.new {|m| m.category_other.blank?}
  
  validates_presence_of :admin_password
  validates_confirmation_of :admin_password
  
  #validates_presence_of :parent_property_id, :if => Proc.new {|m| m.level == 'Property'}, 
  #  :message => 'You must select a Parent Property if you select Property as your Level'
      
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
    
    state :pending
    state :denied
    state :active
    state :inactive
  end
  
  def hash_password_unless_empty
    write_attribute :admin_password, self.class.hash_password(admin_password) unless admin_password.to_s.strip.empty?
  end
    
  def self.login(admin_email, admin_password)
    find(:first, :conditions => ["admin_email = ? and " +
      "admin_password = ? and status = 'active'", admin_email, hash_password(admin_password)])
  end

  def self.hash_password(password)
    Digest::SHA1.hexdigest("#{salt}--#{password}--")
  end
  
  def to_param
    normalized_name = name.to_s.strip.gsub(/[ \.\_\/\\]/, '-').gsub(/[^a-zA-Z0-9\-]/, '')
    "#{self.id}-#{normalized_name}"
  end

end
