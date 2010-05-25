# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class DragExtension < Radiant::Extension
  version "1.0"
  description "Radiant Drag allows you to reorder pages funly"
  url "http://github.com/squaretalent/radiant-drag-extension"
  
  define_routes do |map|
    map.with_options :controller => 'admin/pages' do |page|
      page.page_move_to "admin/pages/:id/move_to/:rel/:pos/:copy", :action => "move_to"
      #going to have to change this once changes are made to acts_as_tree
      #http://groups.google.com/group/radiantcms-dev/browse_thread/thread/83d62f75dc20e645/6833cf5afe0b69a4?lnk=raot&fwc=2
    end
  end
  
  def activate
    admin.pages.index.add :sitemap_head, "drag_order_header", :before=>"title_column_header"
    admin.pages.index.add :node, "drag_order", :before=>"title_column"
    admin.pages.index.add :top, "top"
    
    Page.send :include, Drag::PageExtensions
    Admin::PagesController.send :helper, Drag::PageHelper
    Admin::PagesController.send :include, Drag::PageControllerExtensions
    StandardTags.send :include, Drag::TagExtensions
  end
  
end