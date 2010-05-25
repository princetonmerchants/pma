# Simple example of using a Page Part to manage first-class associations.
# Given the following schema:
#
#   create_table "related_pages", :id => false do |t|
#     t.integer "page_id"
#     t.integer "relation_id"
#   end
#
# ...and this association:
# 
#    class Page < ActiveRecord::Base
#      has_and_belongs_to_many :related_pages, :join_table => :related_pages, 
#                              :association_foreign_key => :relation_id,
#                              :class_name => 'Page'
#    end
#
# ...this Part will create actual joins between a page and its relations. It
# accepts a comma-delimited list of foreign keys (related Page IDs.)
# A complete implementation would provide a better user experience in the form
# of some sort of page-selection interface.

class AssociationPagePart < PagePart
  part_name "Related Pages"

  def before_save
    self.page.related_page_ids = content.split(',')
  end
end