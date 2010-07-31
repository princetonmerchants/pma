ActionController::Routing::Routes.draw do |map|
  map.resources :members, 
    :path_prefix => '/admin', 
    :controller  => 'admin/members', 
    :member => {
      :activate => :post,
      :deactivate => :post
    }
  map.resources :categories, 
    :path_prefix => '/admin', 
    :controller  => 'admin/categories'
end