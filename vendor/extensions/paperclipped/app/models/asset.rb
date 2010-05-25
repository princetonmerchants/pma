class Asset < ActiveRecord::Base

  has_many :page_attachments, :dependent => :destroy
  has_many :pages, :through => :page_attachments

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  has_attached_file :asset,
                    :styles => lambda { |attachment|
                      AssetType.from(attachment.instance_read(:content_type)).paperclip_styles
                    },
                    :processors => lambda { |asset| 
                      asset.paperclip_processors 
                    },
                    :whiny_thumbnails => false,
                    :storage => Radiant::Config["assets.storage"] == "filesystem" ? :filesystem : :s3, 
                    :s3_credentials => {
                      :access_key_id => Radiant::Config["assets.s3.key"],
                      :secret_access_key => Radiant::Config["assets.s3.secret"]
                    },
                    :s3_host_alias  => Radiant::Config['assets.s3.host_alias'],
                    :bucket         => Radiant::Config['assets.s3.bucket'],
                    :url            => Radiant::Config["assets.storage"] == "filesystem" ? "/:class/:basename_:style.:extension" : ":s3_alias_url",
                    :path           => Radiant::Config["assets.storage"] == "filesystem" ? ":rails_root/public/:class/:basename_:style.:extension" : Radiant::Config['assets.s3.path']

  before_save :assign_title
  after_post_process :note_dimensions
  
  validates_uniqueness_of :asset_file_name, :message => "This file already exists"
  validates_attachment_presence :asset, :message => "You must choose a file to upload!"
  validates_attachment_content_type :asset, 
    :content_type => Radiant::Config["assets.content_types"].gsub(' ','').split(',') if Radiant::Config.table_exists? && Radiant::Config["assets.content_types"] && Radiant::Config["assets.skip_filetype_validation"] == nil
  validates_attachment_size :asset, 
    :less_than => Radiant::Config["assets.max_asset_size"].to_i.megabytes if Radiant::Config.table_exists? && Radiant::Config["assets.max_asset_size"]

  def asset_type
    AssetType.from(asset.content_type)
  end
  delegate :paperclip_processors, :paperclip_styles, :style_dimensions, :style_format, :to => :asset_type

  def thumbnail(style_name='original')
    return asset.url if style_name.to_sym == :original
    return asset.url(style_name.to_sym) if has_style?(style_name)
    return "/images/admin/extensions/paperclipped/thumbnails/#{asset_type.name}_#{style_name.to_s}.png"
  end
  
  def has_style?(style_name)
    paperclip_styles.keys.include?(style_name.to_sym)
  end

  def basename
    File.basename(asset_file_name, ".*") if asset_file_name
  end

  def extension
    asset_file_name.split('.').last.downcase if asset_file_name
  end

  # we avoid going back to the file so as not to block page requests with imagemagick calls
  def geometry(style_name='original')
    if style_name == 'original'
      Paperclip::Geometry.parse("#{original_width}x#{original_height}")
    else
      Paperclip::Geometry.parse(style_dimensions(style_name))
    end
  end

  def geometry_from_file
    Paperclip::Geometry.from_file(asset.path)
  rescue Paperclip::NotIdentifiedByImageMagickError
    Paperclip::Geometry.parse("0x0")
  end

  def aspect(style_name='original')
    image? && geometry(style_name).aspect
  end

  def shape(style_name='original')
    if image?
      return 'horizontal' if aspect > 1.0
      return 'vertical' if aspect < 1.0
      return 'square'
    end
  end

  def width(style_name='original')
    image? ? geometry(style_name).width : 0
  end

  def height(style_name='original')
    image? ? geometry(style_name).height : 0
  end

  def square?(style_name='original')
    image? && geometry(style_name).square?
  end

  def vertical?(style_name='original')
    image? && geometry(style_name).vertical?
  end

  def horizontal?(style_name='original')
    image? && geometry(style_name).horizontal?
  end
  
private

  def assign_title
    self.title = basename if title.blank?
  end
  
  def note_dimensions
    if image? && (geometry = geometry_from_file)
      self.original_width = geometry.width
      self.original_height = geometry.height
      self.original_extension = extension
      true
    end
  rescue
    false
  end

  class << self
    def known_types
      AssetType.known_types
    end
    
    def search(search, filter)
      unless search.blank?

        search_cond_sql = []
        search_cond_sql << 'LOWER(asset_file_name) LIKE (:term)'
        search_cond_sql << 'LOWER(title) LIKE (:term)'
        search_cond_sql << 'LOWER(caption) LIKE (:term)'
        cond_sql = search_cond_sql.join(" OR ")

        @conditions = [cond_sql, {:term => "%#{search.downcase}%" }]
      else
        @conditions = []
      end

      options = { :conditions => @conditions,
                  :order => 'created_at DESC' }
                                  
      @asset_types = filter.blank? ? [] : filter.keys
      unless @asset_types.empty?
        with_scope(:find => { :conditions => AssetType.conditions_for(@asset_types) }) do
          find(:all, options)
        end
      else
        find(:all, options)
      end
    end
    
  end

  def self.eigenclass
    class << self; self; end    # returns the return value of class << self block, which is self (as defined within that block)
  end

  def self.define_class_method(name, &block)
    eigenclass.send :define_method, name, &block
  end
  
  # backwards compatibility
  
  def self.thumbnail_sizes
    AssetType.find(:image).paperclip_styles
  end
  
  def self.thumbnail_names
    thumbnail_sizes.keys
  end

  def self.thumbnail_options
    asset_sizes = thumbnail_sizes.collect{|k,v| 
      size_id = k
      size_description = "#{k}: "
      size_description << (v.is_a?(Array) ? v.join(' as ') : v)
      [size_description, size_id] 
    }.sort_by{|pair| pair.last.to_s}
    asset_sizes.unshift ['Original (as uploaded)', 'original']
    asset_sizes
  end

end
