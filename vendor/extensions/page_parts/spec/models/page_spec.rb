require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  it "should upcast page part subclasses before rendering" do
    page = Page.new
    page.should_receive(:parse_object_without_page_part_subclasses).with(an_instance_of(PagePart))
    page.render_snippet(BooleanPagePart.new)
  end
end