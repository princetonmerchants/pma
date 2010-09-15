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
  
  map.connect '/current_member_json', :controller => '/members', :action => 'current_member_json'
  map.connect '/members_search_auto_complete_json', :controller => '/members', :action => 'search_auto_complete_json'
  map.connect '/members_at_auto_complete_json', :controller => '/members', :action => 'at_auto_complete_json'
  map.connect '/others_more_messages', :controller => '/members', :action => 'others_more_messages'
  map.connect '/account_more_messages', :controller => '/members', :action => 'account_more_messages'
  map.resources :members, :only => [:index, :show, :new, :create]
  map.account '/', :controller => '/members', :action => 'account'
  map.edit_account '/edit-account', :controller => '/members', :action => 'edit_account'
  map.update_account '/update-account', :controller => '/members', :action => 'update_account'
  map.change_password '/change-password', :controller => '/members', :action => 'change_password'
  map.update_password '/update-password', :controller => '/members', :action => 'update_password'
  map.member_register '/register', :controller => '/members', :action => 'new'
  map.members_only_profile '/members-only/members/:id', :controller => 'members', :action => 'show_members_only'
  
  map.notifications '/notifications', :controller => 'notifications'
  map.more_notifications '/notifications/more', :controller => 'notifications', :action => 'more'
  map.notifications_quick_look '/notifications/quick_look', :controller => 'notifications', :action => 'quick_look'
  
  map.resource :member_session
  map.member_login '/login', :controller => '/member_sessions', :action => 'new'
  map.member_logout '/logout', :controller => '/member_sessions', :action => 'destroy'
  map.member_logout_first '/logout-first', :controller => '/member_sessions', :action => 'logout_first'
  
  map.resources :password_resets, :path_prefix => '/account'
  
  map.resources :messages, :message_responses, :path_prefix => '/members-only', :only => [:show, :create, :destroy]
  
  map.root :controller => '/members', :action => 'account'
end