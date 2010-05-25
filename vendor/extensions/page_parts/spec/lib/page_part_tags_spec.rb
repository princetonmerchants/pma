require File.dirname(__FILE__) + '/../spec_helper'

describe PageParts::PagePartTags do
  before do
    @page = Page.new(:slug => "/", :parent_id => nil, :title => 'Home')
    @body = PagePart.new(:name => 'body', :content => 'Hello World')
    @page.parts << @body
  end

  describe "if_bool" do
    before do
      @bool = BooleanPagePart.new(:name =>  'bool', :content => true)
      @page.parts << @bool
    end

    it "should expand if part is true" do
      @page.should render('<r:if_bool part="bool">content</r:if_bool>').as('content')
    end
    
    it "should not expand if part is false" do
      @bool.content = false
      @page.should render('<r:if_bool part="bool">content</r:if_bool>').as('')
    end

    it "should throw exception if part is not a boolean" do
      @body.content = '<r:if_bool part="body">content</r:if_bool>'
      lambda {
        @page.render
      }.should raise_error(StandardTags::TagError)
    end
  end
  
  describe "if_earlier" do
    before do
      @date = DatePagePart.new(:name => 'date', :content => Time.now - 1.hour)
      @page.parts << @date
    end

    it "should expand if content is earlier than now" do
      @page.should render('<r:if_earlier part="date">content</r:if_earlier>').as('content')
    end

    it "should not expand if content is later than now" do
      @date.content = Time.now + 1.hour
      @page.should render('<r:if_earlier part="date">content</r:if_earlier>').as('')
    end

    it "should accept an explicit time for comparison" do
      @date.content = 2.weeks.ago
      last_week = 1.week.ago.to_s
      @page.should render("<r:if_earlier than='#{last_week}' part='date'>content</r:if_earlier>").as('content')
    end
  end
  
  describe "if_greater" do
    before do
      @int = IntegerPagePart.new(:name => 'int', :content => 5)
      @page.parts << @int
    end

    it "should expand if content is greater than given attribute" do
      @page.should render('<r:if_greater than="1" part="int">content</r:if_greater>').as('content')
    end

    it "should not expand if content is less than given attribute" do
      @page.should render('<r:if_greater than="10" part="int">content</r:if_greater>').as('')
    end
    
    it "should take OrEqual option" do
      @page.should render('<r:if_greater than="5" orequal="true" part="int">content</r:if_greater>').as('content')
    end
  end
  
  describe "if_equal" do
    before do
      @int = IntegerPagePart.new(:name => 'int', :content => 5)
      @page.parts << @int
    end

    it "should expand if attribute is equal" do
       @page.should render('<r:if_equal to="5" part="int">content</r:if_equal>').as('content')
    end

    it "should not expand if attribute is not equal" do
      @page.should render('<r:if_equal to="10" part="int">content</r:if_equal>').as('')
    end
  end
  
  describe "date" do
    before do
      @date = DatePagePart.new(:name => 'millenium', :content => '1/1/2000')
      @page.parts << @date
    end

    it "should accept a page part" do
      @page.should render('<r:date for="millenium" />').as('Saturday, January 01, 2000')
    end
  end
end