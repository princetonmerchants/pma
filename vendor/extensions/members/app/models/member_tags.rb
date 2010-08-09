module MemberTags  
  include Radiant::Taggable
  
  desc %{
    Cycles through the active members.
    
    *Usage:*
    <pre><code><r:members categorize="false"> ... </r:memnbers></code></pre>
  }
	tag	"members" do |tag|
		params = tag.locals.page.request.parameters
		members = Member.active
    members.collect do |member|
      tag.locals.member = member 
      tag.expand 
    end.join
	end
end