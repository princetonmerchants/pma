ActionController::Routing::Routes.draw do |map|
  map.resources :members, 
    :path_prefix => '/admin', 
    :controller  => 'admin/members', 
    :member => {
      :activate => :post,
      :deactivate => :post
    }
end