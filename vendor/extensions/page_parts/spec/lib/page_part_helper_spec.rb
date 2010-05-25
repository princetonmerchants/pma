require File.dirname(__FILE__) + '/../spec_helper'

describe PageParts::PagePartHelper do
  include PageParts::PagePartHelper

  describe ".parts" do
    it "should return parts array" do
      self.parts.should include(PagePart)
    end
  end
end