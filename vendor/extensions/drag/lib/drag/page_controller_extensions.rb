module Drag::PageControllerExtensions

  def move_to
    @page = Page.find(params[:id])        # the moving page record
    @rel = Page.find(params[:rel])        # the page record of the target of the move
    @loc = params[:pos].to_i              # the moving page current location
    @copy = params[:copy].to_i > 0        # whether this is copied or not
    
    # check first to see if there are any new, incoming pages with nil position values.
    # mimic the way Radiant orders the objects on index page with new positions
    
    all_new_pages = Page.find_all_by_parent_id( @page.parent.id, :conditions => ["position is null"] )
    if(all_new_pages.size > 0)
      all_pages = Page. find_all_by_parent_id( @page.parent.id, :order => ["position ASC"] )
      i = 1
      all_pages.each do |p|
        p.position = i
        p.save
        i += 1
      end
      @page = Page.find(params[:id])
      @rel = Page.find(params[:rel])
    end

    
    # re-establish the incoming page object with its new position (otherwise is still nil)
    
     if !@copy
        # Remove the page from its old position
        @old_siblings = Page.find_all_by_parent_id( @page.parent.id, :conditions => [ "position > " + @page.position.to_s ] )
        @old_siblings.each do |s|
          s.position -= 1
          s.save
        end
      end

      @rel.reload
      if @loc != 2
        # Make room for the page
        @new_siblings = Page.find_all_by_parent_id( @rel.parent.id, :conditions => [ "position >= " + (@rel.position.to_i + @loc).to_s ] )
        @new_siblings.each do |s|
          if s.id != @page.id || @copy
            s.position += 1
            s.save
          end
        end
      end

      if @copy
        # Save reference to parts
        orig_parts = @page.parts
        # Create copy of page
        @page = @page.clone
      end

      # Put the page
      @rel.reload
      old_parent = @page.parent
      if @loc != 2
        @page.parent = @rel.parent
        @page.position = @rel.position.to_i + (@loc == 1 ? 1 : -1)
      else
        @page.parent = @rel
        @page.position = 1
      end

      if @copy || @page.parent != old_parent # @page.parent.changed? always gives false...
        # Check for slug duplication
        check_slug = @page.slug.sub /-copy-?[0-9]*$/, ""
        count = 0
        duplicates = Page.find_all_by_parent_id( @loc == 2 ? @rel.id : @rel.parent.id, :conditions => [ "slug LIKE '#{check_slug}%%'" ] )
        duplicates.each do |d|
          m = d.slug.match("^#{check_slug}(-copy-?([0-9]*))?$")
          if !m.nil?
            if !(m[2].nil? || m[2] == "")
              nc = m[2].to_i + 1
            elsif m[1]
              nc = 2
            else
              nc = 1
            end
            count = nc if nc > count
          end
        end
        if count > 0
          # Remove old copy counters
          re = / - COPY ?[0-9]*$/
          @page.title.sub! re, ""
          @page.breadcrumb.sub! re, ""
          # Add new copy counters
          @page.slug = check_slug + "-copy" + (count > 1 ? "-" + count.to_s : "")
          @page.title += " - COPY" + (count > 1 ? " " + count.to_s : "")
          @page.breadcrumb += " - COPY" + (count > 1 ? " " + count.to_s : "")
        end
      end

      # Save the page
      @page.save

      if @copy
        # Create copy of parts
        orig_parts.each do |op|
          @page.parts.create({
            :name => op.name,
            :filter_id => op.filter_id,
            :content => op.content
          })
        end
      end
    
    # Redirect back to the admin pages page
    request.env["HTTP_REFERER"] ? redirect_to(:back) : redirect_to(admin_page_url)
  end
  
end
