ActionController::Routing::Routes.draw do |map|  
  map.namespace :admin, :member => { :activate => :post, :deactivate => :post } do |admin|
    admin.resources :members
  end
  
  map.namespace :admin do |admin|
    admin.resources :categories
  end
end