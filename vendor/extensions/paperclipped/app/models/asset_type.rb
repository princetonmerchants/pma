class AssetType
  @@types = {}
  @@mime_lookup = {}
  @@default_type = nil
  attr_reader :name, :processors, :styles, :catchall
  
  def initialize(name, options = {})
    options = options.symbolize_keys
    @name = name
    @processors = options[:processors]
    @styles = options[:styles] || {}
    @mimes = options[:mime_types] || []
    if @mimes.any?
      @mimes.each { |mimetype| @@mime_lookup[mimetype] ||= self }
    end
    this = self
    Asset.send :define_method, "#{name}?".intern do this.mime_types.include?(asset_content_type) end 
    Asset.send :define_class_method, "#{name}_condition".intern do this.condition; end
    Asset.send :define_class_method, "not_#{name}_condition".intern do this.non_condition; end
    Asset.send :named_scope, name.to_s.pluralize.intern, :conditions => condition
    Asset.send :named_scope, "not_#{name.to_s.pluralize}".intern, :conditions => non_condition
    @@types[@name] = self
  end

  def condition
    if @mimes.any?
      ["asset_content_type IN (#{@mimes.map{'?'}.join(',')})", *@mimes]
    else
      self.class.other_condition
    end
  end
  
  def sanitized_condition
    ActiveRecord::Base.send :sanitize_sql_array, condition
  end

  def non_condition
    if @mimes.any?
      ["NOT asset_content_type IN (#{@mimes.map{'?'}.join(',')})", *@mimes]
    else
      self.class.non_other_condition
    end
  end

  def sanitized_non_condition
    ActiveRecord::Base.send :sanitize_sql_array, non_condition
  end

  def mime_types
    @mimes
  end

  def paperclip_processors
    processors || []
  end
  
  def paperclip_styles
    styles.merge(configured_styles)
  end

  def configured_styles
    styles = []
    styles = Radiant::Config["assets.additional_#{name}_thumbnails"].gsub(/\s+/,'').split(',') if Radiant::Config["assets.additional_#{name}_thumbnails"]
    styles += Radiant::Config["assets.additional_thumbnails"].gsub(/\s+/,'').split(',') if name == :image && Radiant::Config["assets.additional_thumbnails"]
    styles.collect{|s| s.split('=')}.inject({}) {|ha, (k, v)| ha[k.to_sym] = v; ha}
  end

  def style_dimensions(style_name)
    if style = paperclip_styles[style_name.to_sym]
      style.is_a?(Array) ? style.first : style
    end
  end
  
  def style_format(style_name)
    if style = paperclip_styles[style_name.to_sym]
      style.last if style.is_a?(Array)
    end
  end

  # class methods
  
  def self.from(mimetype)
    @@mime_lookup[mimetype] || catchall
  end
  
  def self.catchall
    @@default_type ||= new :other
  end
  
  def self.known?(name)
    !@@types[name.to_sym].nil?
  end

  def self.find(name)
    @@types[name.to_sym]
  end
  
  def self.known_types
    @@types.keys
  end

  def self.known_mimetypes
    @@mime_lookup.keys
  end
    
  def self.mime_types_for(*names)
    names.collect{ |name| find(name).mime_types }.flatten
  end

  def self.conditions_for(names)
    names.collect{ |name| self.find(name).sanitized_condition }.join(' OR ')
  end

  def self.non_other_condition
    ["asset_content_type IN (#{known_mimetypes.map{'?'}.join(',')})", *known_mimetypes]
  end

  def self.other_condition
    ["NOT asset_content_type IN (#{known_mimetypes.map{'?'}.join(',')})", *known_mimetypes]
  end

end
