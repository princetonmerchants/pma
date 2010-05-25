# Very basic Paperclip-based file attachment via a page part. This Part will
# render the file's path for use in IMG or other tags.

class FilePagePart < PagePart  
  has_attached_file :document
  attr_accessor :delete

  def before_save
    self.document.clear if delete
  end

  def render_content
    self.document.url
  end
end