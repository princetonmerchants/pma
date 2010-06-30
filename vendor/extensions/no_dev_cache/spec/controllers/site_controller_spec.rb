require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  dataset :pages

  describe "caching" do
    
    it "should prevent upstream caching in dev mode" do
      controller.config = { 'dev.host' => 'mysite.com' }
      request.host = 'mysite.com'
      
      get :show_page, :url => '/'
      response.headers['Cache-Control'].should =~ /private/
      response.headers['Cache-Control'].should =~ /no-cache/
      response.headers['ETag'].should be_blank
    end
  end
end