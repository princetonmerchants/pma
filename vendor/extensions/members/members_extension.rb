# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class MembersExtension < Radiant::Extension
  version "1.0"
  description "Members for PMA"
  url "http://comsoft155.com/"
  
  extension_config do |config|
    config.gem 'state_machine'
  end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    tab 'Membership' do
       add_item "Members", "/admin/members"
       add_item "Categories", "/admin/categories"
    end
  end
end
