require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  dataset :pages

  before(:each) do
    # don't bork results with stale cache items
    controller.cache.clear
  end

  it "should find and render home page" do
    get :show_page, :url => ''
    response.should be_success
    response.body.should == 'Hello world!'
  end
  
  it "should find a page one level deep" do
    get :show_page, :url => 'first/'
    response.should be_success
    response.body.should == 'First body.'
  end  
end