class EventDayIndexPage < Page

  include ArchiveIndexTagsAndMethods

  def breadcrumb
    if request_uri =~ %r{/(\d{4})/(\d{2})/(\d{2})/?$}
      year, month, day = $1, $2, $3
      Date.new(year.to_i, month.to_i, day.to_i).strftime("%d, %B %Y")
    else
      super
    end
  end

  def title
    breadcrumb
  end

  class << ArchiveFinder
    def event_month_finder(finder, year, month)
      new do |method, options|
        start = Time.local(year, month)
        finish = start.next_month
        add_condition(options, "event_datetime_start >= ? and event_datetime_start < ?", start, finish)
        finder.find(method, options)
      end
    end
  end

  tag "archive:children" do |tag|
    year, month, day = $1, $2, $3 if request_uri =~ %r{/(\d{4})/(\d{2})/(\d{2})/?$}
    tag.locals.children = ArchiveFinder.event_month_finder(parent.children, year, month)
    tag.expand
  end

  tag "archive:unless_children" do |tag|
    year, month, day = $1, $2, $3 if request_uri =~ %r{/(\d{4})/(\d{2})/(\d{2})/?$}
    if ArchiveFinder.event_month_finder(parent.children, year, month).find(:all).empty?
      tag.expand
    end
  end
end