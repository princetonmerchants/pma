module RedirectPageTags
  include Radiant::Taggable

  tag "if_redirect_page" do |tag|
    tag.expand if tag.locals.page.is_a? RedirectPage
  end

  tag "unless_redirect_page" do |tag|
    tag.expand unless tag.locals.page.is_a? RedirectPage
  end

end