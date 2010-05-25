require File.dirname(__FILE__) + '/../spec_helper'

describe BooleanPagePart do
  it "should initialize with boolean" do
    part = BooleanPagePart.new(:content => true)
    part.boolean_content.should be_true
  end

  it "should alias boolean content" do
    part = BooleanPagePart.new(:content => true)
    part.content.should be_true
  end

  it "should translate content when upcast" do
    part = BooleanPagePart.new(:content => true)
    casted = part.becomes(PagePart)
    casted.content.should eql('true')
  end
end

describe IntegerPagePart do
  it "should initialize with integer" do
    part = IntegerPagePart.new(:content => 12345)
    part.integer_content.should eql(12345)
  end

  it "should alias integer content" do
    part = IntegerPagePart.new(:content => 12345)
    part.content.should eql(12345)
  end

  it "should translate content when upcast" do
    part = IntegerPagePart.new(:content => 12345)
    casted = part.becomes(PagePart)
    casted.content.should eql('12345')
  end
end

describe DatePagePart do
  it "should initialize with datetime" do
    t = Time.now
    part = DatePagePart.new(:content => t)
    part.datetime_content.should eql(t)
  end

  it "should alias datetime content" do
    t = Time.now
    part = DatePagePart.new(:content => t)
    part.content.should eql(t)
  end

  it "should translate content when upcast" do
    t = Time.now
    part = DatePagePart.new(:content => t)
    casted = part.becomes(PagePart)
    casted.content.should eql(t.to_s)
  end
end

describe (class SubclassPagePart < PagePart ; end) do
  describe ".part_name" do
    it "should be humanized classname" do
      SubclassPagePart.part_name.should eql('Subclass')
    end
    it "should be overridden with .part_name" do
      SubclassPagePart.part_name "A nice name"
      SubclassPagePart.part_name.should eql('A nice name')
    end
  end
end
