ActionController::Routing::Routes.draw do |map|  
  map.namespace :admin, :member => { 
      :activate => :post, 
      :deactivate => :post, 
      :deny => :post,
      :edit_password => :get,
      :update_password => :put
    } do |admin|
    admin.resources :members
    admin.resources :categories
  end
  
  map.resources :members, :only => [:index, :show, :new, :create]
  map.account '/account', :controller => '/members', :action => 'account'
  map.edit_account '/account/edit', :controller => '/members', :action => 'edit_account'
  map.update_account '/account/update', :controller => '/members', :action => 'update_account'
  map.member_register '/register', :controller => '/members', :action => 'new'
  map.members_only_profile '/members-only/:id', :controller => 'members', :action => 'show_members_only'
  
  map.resource :member_session
  map.member_login '/login', :controller => '/member_sessions', :action => 'new'
  map.member_logout '/logout', :controller => '/member_sessions', :action => 'destroy'
  map.member_logout_first '/logout-first', :controller => '/member_sessions', :action => 'logout_first'
  map.connect '/current-member.js', :controller => '/member_sessions', :action => 'current_member_js'
  
  map.resources :password_resets, :path_prefix => '/account'
end