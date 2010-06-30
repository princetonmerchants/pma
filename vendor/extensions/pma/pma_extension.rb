# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class PmaExtension < Radiant::Extension
  version "1.0"
  description "Membership, checkout, and more for the PMA"
  url "http://www.comsoft155.com/"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    # tab 'Content' do
    #   add_item "Pma", "/admin/pma", :after => "Pages"
    # end
  end
end
