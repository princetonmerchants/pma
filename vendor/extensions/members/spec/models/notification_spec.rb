require File.dirname(__FILE__) + '/../spec_helper'

describe Notification do
  before(:each) do
    @notification = Notification.new
  end

  it "should be valid" do
    @notification.should be_valid
  end
end
