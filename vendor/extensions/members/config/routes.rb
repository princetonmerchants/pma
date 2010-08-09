ActionController::Routing::Routes.draw do |map|  
  map.namespace :admin, :member => { 
      :activate => :post, 
      :deactivate => :post, 
      :deny => :post,
      :edit_password => :get,
      :update_password => :put
    } do |admin|
    admin.resources :members
  end
  
  map.namespace :admin do |admin|
    admin.resources :categories
  end
  
  map.resources :members, :path_prefix => '/membership'
end