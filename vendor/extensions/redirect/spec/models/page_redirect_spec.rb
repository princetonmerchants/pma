require File.dirname(__FILE__) + '/../spec_helper'

describe RedirectPage do
  before(:each) do
    @root = Page.find_by_parent_id(nil)
    @page = RedirectPage.new( :title => 'Redirect',
                              :breadcrumb => 'redirect',
                              :slug => "redirect",
                              :status => '',
                              :parent_id => @root.id)
  end

  it "should err without a page part" do
    @page.valid?
    @page.errors.on(:base).should match(/requires one page part/)
  end

  it "should err without a redirect_url" do
    @page.parts.build(:name => 'body', :content => nil)
    @page.valid?
    @page.errors.on(:base).should match(/page part can't be empty/)
  end

  it "should remove the first character from redirect_url beginning with a slash" do
    @page.parts.build(:name => 'body', :content => "/things")  
    @page.save
    @page.redirect_url.should == 'things'
  end

  it "should remove consecutive slashes from the catch_url before saving" do
    @page.parts.build(:name => 'body', :content => "///slasher")
    @page.save
    @page.redirect_url.should == 'slasher'
  end

  it "should remove consecutive slashes from the redirect_url before saving" do
    @page.parts.build(:name => 'body', :content => "///chop")
    @page.save
    @page.redirect_url.should == 'chop'
  end

  it "should remove all whitespace from redirect_url before saving" do
    @page.parts.build(:name => 'body', :content => "how are you")
    @page.save
    @page.redirect_url.should == 'howareyou'    
  end

  it "should allow '/' as the redirect_url" do
    @page.parts.build(:name => 'body', :content => "/")
    @page.save
    @page.redirect_url.should == '/'
  end
  
  it "should allow a redirect_url formatted like 'http://www.saturnflyer.com/'" do
    @page.parts.build(:name => 'body', :content => 'http://www.saturnflyer.com/')    
    @page.save!
    @page.redirect_url.should == 'http://www.saturnflyer.com/'
  end

  it "should err with 'Redirect URL may not be the same.' when given a catch_url that matches the redirect_url" do
    @page.parts.build(:name => 'body', :content => 'redirect')
    @page.save
    @page.errors.on(:base).should match(/Redirect URL may not be the same/)
  end

  it "should render if_redirect_page if a RedirectPage" do
    @page.should render(%{<r:if_redirect_page><r:title /></r:if_redirect_page>}).
      as("Redirect")
  end

  it "should not render if_redirect_page if not a RedirectPage" do
    @root.should render(%{<r:if_redirect_page><r:title /></r:if_redirect_page>}).
      as("")
  end

  it "should not render unless_redirect_page if a RedirectPage" do
    @page.should render(%{<r:unless_redirect_page><r:title /></r:unless_redirect_page>}).
      as("")
  end

  it "should render unless_redirect_page if not a RedirectPage" do
    @root.should render(%{<r:unless_redirect_page><r:title /></r:unless_redirect_page>}).
      as("Home")
  end

  # it "should err with 'Redirect URL may not be an existing redirect' when given a catch_url that matches the redirect_url" do
  #   @page.parts.build(:name => 'body', :content => 'things')
  #   @page.save!
  #   page2 = RedirectPage.new(:title => 'Redirect2',
  #                             :breadcrumb => 'redirect2',
  #                             :slug => "redirect2",
  #                             :status => '',
  #                             :parent_id => @root.id)
  #   page2.parts.build(:name => 'body', :content => 'things')                              
  #   lambda {page2.save!}.should raise_error(RedirectPage::DataMismatch, "Redirect URL may not be an existing redirect.")
  # end

end