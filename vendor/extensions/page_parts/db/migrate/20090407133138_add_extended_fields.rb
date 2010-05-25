class AddExtendedFields < ActiveRecord::Migration
  def self.up
    add_column :page_parts, :page_part_type, :string
    add_column :page_parts, :string_content, :string
    add_column :page_parts, :boolean_content, :boolean
    add_column :page_parts, :integer_content, :integer
    add_column :page_parts, :datetime_content, :datetime
  end

  def self.down
    remove_column :page_parts, :datetime_content
    remove_column :page_parts, :integer_content
    remove_column :page_parts, :boolean_content
    remove_column :page_parts, :string_content
    remove_column :page_parts, :page_part_type
  end
end
