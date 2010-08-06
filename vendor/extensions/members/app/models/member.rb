class Member < ActiveRecord::Base
  belongs_to :category

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
  
  #validates_presence_of :email
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :email, :with => email_regex, :allow_blank => true
  
  validates_uniqueness_of :website, :allow_blank => true
  validates_format_of :website, :with => domain_regex, :allow_blank => true

  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :category_id
  
  def initialize 
    super
    chars = ("a".."z").collect + ("2".."9").collect + %w{ ! # $ % ^ , - = @ . }
    self[:password] ||= Array.new(8, '').collect{chars[rand(chars.size)]}.join
  end
  
  state_machine :status, :initial => :pending do
    event :activate do
      transition [:inactive, :pending, :active] => :active
    end
    event :deactivate do
      transition [:inactive, :pending, :active] => :inactive
    end
    event :pending do
      transition :pending => :inactive
    end
    
    state :pending
    state :active
    state :inactive
  end
end
