# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class NavigationExtension < Radiant::Extension
  version "2.0.1"
  description "Makes building navigations much easier."
  url "http://github.com/squaretalent/radiant-navigation-extension"
  
  def activate
    Page.send :include, NavigationTags
  end
  
end