require File.dirname(__FILE__) + '/../../spec_helper'

describe "/members/new" do
  before do
    render 'members/new'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', 'Find me in app/views/members/new.rhtml')
  end
end