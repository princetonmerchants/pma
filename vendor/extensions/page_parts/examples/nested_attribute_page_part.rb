# Example of using a PagePart to manage nested attributes for a Page.
# Given a Book class with this schema:
#
#     create_table :books do |t|
#       t.string :title, :isbn
#       t.belongs_to :page
#     end
#
# ...and this addition to the Page class:
#
#     class Page < ActiveRecord::Base
#       has_one :favorite_book, :class_name => 'Book'
#     end
#
# ...this Part will manage the display of the nested form attributes for the
# `favorite_book` association. See the example partial for implementation.

class NestedAttributePagePart < PagePart
  part_name "Favorite Book"
end