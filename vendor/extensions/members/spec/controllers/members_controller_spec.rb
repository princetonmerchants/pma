require File.dirname(__FILE__) + '/../spec_helper'

describe MembersController do

  #Delete these examples and add some real ones
  it "should use MembersController" do
    controller.should be_an_instance_of(MembersController)
  end


  it "GET 'index' should be successful" do
    get 'index'
    response.should be_success
  end

  it "GET 'show' should be successful" do
    get 'show'
    response.should be_success
  end

  it "GET 'new' should be successful" do
    get 'new'
    response.should be_success
  end

  it "GET 'create' should be successful" do
    get 'create'
    response.should be_success
  end

  it "GET 'edit' should be successful" do
    get 'edit'
    response.should be_success
  end

  it "GET 'update' should be successful" do
    get 'update'
    response.should be_success
  end
end
