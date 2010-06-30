# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class NoDevCacheExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/no_dev_cache"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :no_dev_cache
  #   end
  # end
  
  def activate
    SiteController.send :include, NoDevCache::SiteControllerExtensions
    # admin.tabs.add "No Dev Cache", "/admin/no_dev_cache", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "No Dev Cache"
  end
  
end
