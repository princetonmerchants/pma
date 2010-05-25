module PageParts
  module PageExtensions
    def self.included(base)
      base.class_eval do
        # Recast everything to base class so it's all transparent to the parser
        def parse_object_with_page_part_subclasses(object)
          object = object.becomes(PagePart) if object.class < PagePart
          parse_object_without_page_part_subclasses(object)
        end
        alias_method_chain :parse_object, :page_part_subclasses
      end
    end
  end
end