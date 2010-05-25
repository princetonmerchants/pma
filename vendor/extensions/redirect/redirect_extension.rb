# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RedirectExtension < Radiant::Extension
  version "0.1"
  description "A redirect page will redirect to the url defined in the body part"
  url "http://github.com/squaretalent/radiant-redirect-extension"
  
  def activate
    SiteController.send :include, PageRedirect::ControllerExtensions
    Page.class_eval do
      include RedirectPageTags
    end
  end
  
end
