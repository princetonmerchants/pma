# require_dependency 'application_controller'
# require File.dirname(__FILE__) + '/lib/url_additions'
# include UrlAdditions


require 'paperclip'
class PaperclippedExtension < Radiant::Extension
  version "0.9"
  description "Assets extension based on the lightweight Paperclip plugin."
  url "http://github.com/squaretalent/radiant-paperclipped-extension"
  
  define_routes do |map|
    
    # Main RESTful routes for Assets
    map.namespace :admin, :member => { :remove => :get }, :collection => { :refresh => :post } do |admin|
      admin.resources :assets
    end
    
    # Bucket routes
    map.with_options(:controller => 'admin/assets') do |asset|
      asset.add_bucket        "/admin/assets/:id/add",                   :action => 'add_bucket'
      asset.clear_bucket      "/admin/assets/clear_bucket",              :action => 'clear_bucket'
      asset.reorder_assets    '/admin/assets/reorder/:id',               :action => 'reorder'
      asset.attach_page_asset '/admin/assets/attach/:asset/page/:page',  :action => 'attach_asset'
      asset.remove_page_asset '/admin/assets/remove/:asset/page/:page',  :action => 'remove_asset'
    end
    
    # File downloader
    map.resources :assets, :only => :show
  end
  
  extension_config do |config|
    config.gem 'paperclip', :version => '~> 2.3.1.1', :source => 'http://gemcutter.org'
    config.gem 'aws-s3', :lib => 'aws/s3', :version => '~> 0.6.2', :source => 'http://gemcutter.org'
    config.gem 'acts_as_list', :source => 'http://gemcutter.org'
    config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
    config.gem 'responds_to_parent', :source => 'http://gemcutter.org'

    config.after_initialize do
      Paperclip.interpolates :no_original_style do |attachment, style|
        style ||= :original
        style == attachment.default_style ? nil : "_#{style}"
      end
    end
  end
  
  def activate
    AssetType.new :image, :mime_types => %w[image/png image/x-png image/jpeg image/pjpeg image/jpg image/gif], :processors => [:thumbnail], :styles => {:icon => ['42x42#', :png], :thumbnail => ['100x100>', :png]}
    AssetType.new :video, :mime_types => %w[video/mpeg video/mp4 video/ogg video/quicktime video/x-ms-wmv video/x-flv]
    AssetType.new :audio, :mime_types => %w[audio/mpeg audio/mpg audio/ogg application/ogg audio/x-ms-wma audio/vnd.rn-realaudio audio/x-wav]
    AssetType.new :swf, :mime_types => %w[application/x-shockwave-flash]
    AssetType.new :pdf, :mime_types => %w[application/pdf application/x-pdf]
    # alias for backwards-compatibility: movie could previously be either video or flash.
    # (existing mime-type lookup table is not affected but methods like Asset#movie? are created)
    AssetType.new :movie, :mime_types => AssetType.mime_types_for(:video, :swf)
    # a type with no mime-types is assumed to mean 'everything else'
    AssetType.new :other
    
    unless defined? admin.asset # UI is a singleton and already loaded
      Radiant::AdminUI.send :include, AssetsAdminUI
      admin.asset = Radiant::AdminUI.load_default_asset_regions
    end
    
    admin.page.edit.add :main, "/admin/assets/top"
    admin.page.edit.add :main, "/admin/bucket/show_bucket_link", :before => "edit_header"
    admin.page.edit.add :main, "/admin/bucket/assets_bucket", :after => "edit_buttons"
    
    %w{page}.each do |view|
      admin.send(view).edit.asset_tabs.concat %w{attachment_tab bucket_tab upload_tab search_tab}
      admin.send(view).edit.bucket_pane.concat %w{bucket_notes bucket bucket_bottom}
      admin.send(view).edit.asset_panes.concat %w{page_attachments upload search}
    end
    
    Page.class_eval {
      include PageAssetAssociations
      include AssetTags
    }

    UserActionObserver.instance.send :add_observer!, Asset 
    
    # This is just needed for testing if you are using mod_rails
    if Radiant::Config.table_exists? && Radiant::Config["assets.image_magick_path"]
      Paperclip.options[:command_path] = Radiant::Config["assets.image_magick_path"]
    end
    
    tab 'Content' do
      add_item 'Assets', '/admin/assets', :after => 'Pages'
    end
    
  end
  
end
