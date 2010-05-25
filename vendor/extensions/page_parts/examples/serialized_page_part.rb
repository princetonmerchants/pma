# Serialization for simple Ruby objects like Arrays and Hashes. You'll
# probably want to draw your data values from a more interesting source.

class SerializedPagePart < PagePart
  serialize :content

  def self.colors
    %w(Red Blue Green Cyan Magenta Yellow)
  end

  def self.part_name
    "Serialized Data"
  end

  def after_initialize
    self.content ||= {}
  end
end