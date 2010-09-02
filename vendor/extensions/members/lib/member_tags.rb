module MemberTags  
  include Radiant::Taggable
  
  desc %{
    Cycles through the active members.
    
    *Usage:*
    <pre><code><r:members> ... </r:members></code></pre>
  }
	tag	"members" do |tag|
		order = tag.attr['order'] || 'asc'
		by = tag.attr['by'] || 'name'
		members = Member.active.find(:all, :order => "#{by} #{order}")
    members.collect do |member|
      tag.locals.member = member 
      tag.expand 
    end.join
	end
  
  desc %{   
    Renders the specified field for the member.
  
    *Usage:*
    <pre><code><r:member field="[company_name|company_phone|company_email|website|...]" /></code></pre>
  }
	tag	"member" do |tag|
		tag.locals.member.send(tag.attr['field'])
	end
end