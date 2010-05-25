require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PagePartsController do
  dataset :users
  
  before do
    login_as :admin
  end
  
  it "should assign a subclassed page part" do
    xhr :post, :create, :page_part => { :name => "boolean", :page_part_type => "BooleanPagePart" }
    attr = assigns(:page_part)
    attr.should be_kind_of(BooleanPagePart)
    attr.name.should eql('boolean')
  end
  
end