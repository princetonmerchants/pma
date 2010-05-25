class AddContentIndexes < ActiveRecord::Migration
  def self.up
    add_index :page_parts, :string_content
    add_index :page_parts, :boolean_content
    add_index :page_parts, :integer_content
    add_index :page_parts, :datetime_content
  end

  def self.down
    remove_index :page_parts, :datetime_content
    remove_index :page_parts, :integer_content
    remove_index :page_parts, :boolean_content
    remove_index :page_parts, :string_content
  end
end
