require_dependency 'application_controller'

class PagePartsExtension < Radiant::Extension
  version "0.9"
  description "Manage rich content through page parts"
  url "http://digitalpulp.com"
  
  def activate
    PagePart.send(:include, PageParts::PagePartExtensions)
    Page.send(:include, PageParts::PageExtensions, PageParts::PagePartTags)
    Admin::ResourceController.prepend_view_path 'app/views'
    Admin::PagesController.helper PageParts::PagePartHelper
    ActiveSupport::Dependencies.load_paths << File.join(Rails.root, %w(app models))
    require 'page_parts/standard_tags'
  end

  def deactivate
  end

end
