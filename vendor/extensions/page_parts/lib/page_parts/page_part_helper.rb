module PageParts::PagePartHelper
  ##
  # If you need to limit what parts can be added to specific pages, alias
  # chain this method. The current user and @page are available here, so you
  # could filter by @page.class_name, current_user roles, &c.
  #
  # @return [Array] an array of PagePart classes which you may then modify
  #
  # @example Don't allow file uploads on virtual pages
  #   def parts_with_permissions
  #     if @page.is_a? VirtualPage
  #       parts_without_permissions.reject { |p| p <= FilePagePart }
  #     else
  #       parts_without_permissions
  #     end
  #   end
  #   alias_method_chain :parts, :permissions
  def parts
    [PagePart, *PagePart.descendants]
  end
end