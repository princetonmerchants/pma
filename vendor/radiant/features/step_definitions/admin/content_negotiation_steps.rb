When /^I send an "([^\"]*)" header of "([^\"]*)"$/ do |key, value|
  @request_headers ||= {}
  @request_headers[key] = value
  set_headers
end

When /^I view a page$/ do
  visit "/admin/pages/#{pages(:home).id}"
end

When /^I view a snippet$/ do
  visit "/admin/snippets/#{snippets(:first).id}"
end

When /^I view a layout$/ do
  visit "/admin/layouts/#{layouts(:main).id}"
end

When /^I view a user$/ do
  visit "/admin/users/#{users(:admin).id}"
end

When /^I request the children of page "([^\"]*)"$/ do |page|
  parent_page = pages(page.intern)
  set_headers
  visit "/admin/pages/#{parent_page.id}/children", :get, {"level" => "0"}
end

Then /^(?:|I )should see "<{0,1}([^>"]*)>{0,1}" tags in the page source$/ do |text|
  response.body.should have_tag(text)
end

Then /^(?:|I )should see an xml document$/ do
  webrat.adapter.xml_content_type?.should be_true
end

Then /^(?:|I )should not see an xml document$/ do
  webrat.adapter.xml_content_type?.should_not be_true
end

def set_headers
  @request_headers.each do |k,v|
    header(k, v)
  end unless @request_headers.blank?
end

