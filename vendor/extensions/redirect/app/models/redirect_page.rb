class RedirectPage < Page
  class DataMismatch < StandardError; end

  description %{
    A redirect page will redirect to the url defined in the body part
  }
  after_validation :clean_redirect_url
  validate :redirect_url_not_empty
  validate :redirect_url_not_restricted

  def redirect_url
    parts.first && parts.first.content
  end

  private

  def redirect_url_not_restricted
    if slug == redirect_url
      errors.add(:base, "Redirect URL may not be the same.")
    end
    # if redirect_url
    #   puts "redirect_url #{redirect_url}"
    #   puts Page.all.map(&:inspect)
    #   page = Page.find_by_url(redirect_url, true) || Page.find_by_url(redirect_url, false)
    #   puts page.inspect
    #   if page && page.is_a?(RedirectPage) && page.redirect_url == redirect_url
    #     raise DataMismatch, "Redirect URL may not be the same."
    #   end
    # end
  end

  def redirect_url_not_empty
    if parts.size == 0
      errors.add(:base, "requires one page part")
    elsif redirect_url.blank?
      errors.add(:base, "page part can\'t be empty")
    end
  end
    
  def clean_redirect_url
    unless redirect_url.blank? or redirect_url.match('^http://')
      new_url = redirect_url.gsub(%r{//+},'/').gsub(%r{\s+},'')
      new_url.gsub!(%r{\/$},'') unless new_url == '/'
      new_url.gsub!(%r{^/},'') unless new_url == '/'
      parts.first.update_attributes!(:content => new_url)
    end
  end

end