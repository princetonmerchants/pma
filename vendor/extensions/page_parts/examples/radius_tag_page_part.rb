# Contrived example showing how you might wrap a lower-level Radius tag
# (or tags, if you're building out something complex) inside a friendlier
# form interface. This Part will render the r:date tag with the format and
# attribute you specify.

class RadiusTagPagePart < PagePart
  serialize :content

  def render_content
    "<r:date for='#{for_date}' format='#{date_format}' />"
  end

  def for_date
    content['for_date']
  end

  def date_format
    content['date_format']
  end

  def after_initialize
    self.content ||= {}
  end

end