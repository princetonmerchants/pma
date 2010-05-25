module PageParts
  module PagePartTags
    
    include Radiant::Taggable

    desc %{
      Given the name of a boolean page part, expands if that part's value is true.
      
      *Usage:*
      
      <pre><code><r:if_bool part="boolean part name">...</r:if_bool></code></pre>
    }
    tag 'if_bool' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not a BooleanPagePart") unless part.is_a?(BooleanPagePart)
      tag.expand if part.content?
    end
    
    desc %{
      Given the name of a boolean page part, expands unless that part's value is true.
      
      *Usage:*
      
      <pre><code><r:unless_bool part="boolean part name">...</r:unless_bool></code></pre>
    }
    tag 'unless_bool' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not a BooleanPagePart") unless part.is_a?(BooleanPagePart)
      tag.expand unless part.content?
    end
    
    desc %{
      Given the name of a date page part, expands if that part's value is earlier
      than @Time.now@. Accepts an optional @than@ parameter if you need to compare the
      value to something other than @Time.now@. @than@ can be any string parseable by DateTime.
      
      *Usage:*
      
      <pre><code><r:if_earlier [than="April 7 2009"] part="datetime part name">...</r:if_earlier></code></pre>
    }  
    tag 'if_earlier' do |tag|
      page = tag.locals.page
      comparison = tag.attr['than'] ? DateTime.parse(tag.attr['than']) : DateTime.now
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not a DatePagePart") unless part.is_a?(DatePagePart)
      tag.expand if part.content < comparison
    end
    
    desc %{
      Given the name of a datetime page part, expands if that part's value is later 
      than @Time.now@. Accepts an optional @than@ parameter if you need to compare the
      value to something other than @Time.now@. @than@ can be any string parseable by DateTime.
      
      *Usage:*
      
      <pre><code><r:if_later [than="April 7 2009"] part="datetime part name">...</r:if_later></code></pre>
    }
    tag 'if_later' do |tag|
      page = tag.locals.page
      comparison = tag.attr['than'] ? DateTime.parse(tag.attr['than']) : DateTime.now
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not a DatetimePagePart") unless part.is_a?(DatePagePart)
      tag.expand if part.content > comparison
    end
    
    desc %{
      Given the name of an integer page part, compares it to the required @than@ attribute. The tag
      expands if the content is greater than the compared value. An optional @orequal@ attribute may
      be passed to do a greater-or-equal comparison. @orequal@ defaults to false.
        
      *Usage:*
      <pre><code><r:if_greater than="100" [orequal="true|false"] part="integer part name">...</r:if_greater></code></pre>
    }
    tag 'if_greater' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      orequal = (tag.attr['orequal'].to_s =~ /true/i)
      raise StandardTags::TagError.new("`if_greater' requires a `than' attribute") unless tag.attr['than']
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not an IntegerPagePart") unless part.is_a?(IntegerPagePart)
      if orequal
        tag.expand if part.content >= tag.attr['than'].to_i
      else
        tag.expand if part.content > tag.attr['than'].to_i
      end
    end
    
    desc %{
      Given the name of an integer page part, compares it to the required @than@ attribute. The tag
      expands if the content is less than the compared value. An optional @orequal@ attribute may be
      passed to do a less-than-or-equal comparison. @orequal@ defaults to false.
        
      *Usage:*
      <pre><code><r:if_less than="100" [orequal="true|false"] part="integer part name">...</r:if_less></code></pre>
    }
    tag 'if_less' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      orequal = (tag.attr[:orequal].to_s =~ /true/i)
      raise StandardTags::TagError.new("`if_less' requires a `than' attribute") unless tag.attr['than']
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not an IntegerPagePart") unless part.is_a?(IntegerPagePart)
      if orequal
        tag.expand if part.content <= tag.attr['than'].to_i
      else
        tag.expand if part.content < tag.attr['than'].to_i
      end
    end
    
    desc %{
      Given the name of an integer part, expands if the content is equal to the required @to@ attribute.

      *Usage:*
      <pre><code><r:if_equal to="100" part="integer part name">...</r:if_equal></code></pre>
    }
    tag 'if_equal' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`if_equal' requires a `to' attribute") unless tag.attr['to']
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not an IntegerPagePart") unless part.is_a?(IntegerPagePart)
      tag.expand if part.content == tag.attr['to'].to_i
    end
    
    desc %{
      Given the name of an integer part, expands unless the content is equal to the required @to@ attribute.

      *Usage:*
      <pre><code><r:unless_equal to="100" part="integer part name">...</r:unless_equal></code></pre>
    }
    tag 'unless_equal' do |tag|
      page = tag.locals.page
      part = page.part(tag.attr['part'])
      raise StandardTags::TagError.new("`unless_equal' requires a `to' attribute") unless tag.attr['to']
      raise StandardTags::TagError.new("`#{tag.attr['part']}' is not an IntegerPagePart") unless part.is_a?(IntegerPagePart)
      tag.expand unless part.content == tag.attr['to'].to_i
    end

  end
end