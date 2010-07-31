# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class PmaExtension < Radiant::Extension
  version "1.0"
  description "Members for PMA"
  url "http://comsoft155.com/"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    tab 'Membership' do
       add_item "Members", "/admin/members"
       add_item "Categories", "/admin/categories"
    end
  end
end
