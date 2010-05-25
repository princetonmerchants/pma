module StandardTags
  desc %{
    Renders the date based on the current page (by default when it was published or created).
    The format attribute uses the same formating codes used by the Ruby @strftime@ function. By
    default it's set to @%A, %B %d, %Y@.  The @for@ attribute selects which date to render.  Valid
    options are @published_at@, @created_at@, @updated_at@, @now@, or the name of any datetime
    page part. @now@ will render the current date/time, regardless of the  page.

    *Usage:*

    <pre><code><r:date [format="%A, %B %d, %Y"] [for="published_at"]/></code></pre>
  }
  tag 'date' do |tag|
    page = tag.locals.page
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    time_attr = tag.attr['for']
    date = if time_attr
      case
      when time_attr == 'now'
        Time.now
      when ['published_at', 'created_at', 'updated_at'].include?(time_attr)
        page[time_attr]
      else
        if part = page.part(time_attr)
          part.content
        else
          raise TagError, "Invalid value for 'for' attribute."
        end
      end
    else
      page.published_at || page.created_at
    end
    date.strftime(format)
  end  
end