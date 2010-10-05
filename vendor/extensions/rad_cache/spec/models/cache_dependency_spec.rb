require File.dirname(__FILE__) + '/../spec_helper'

describe CacheDependency do
  before(:each) do
    @cache_dependency = CacheDependency.new
  end

  it "should be valid" do
    @cache_dependency.should be_valid
  end
end
