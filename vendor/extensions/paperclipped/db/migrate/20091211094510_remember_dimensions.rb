class RememberDimensions < ActiveRecord::Migration
  def self.up
    add_column :assets, :original_width, :integer
    add_column :assets, :original_height, :integer
    add_column :assets, :original_extension, :string
  end

  def self.down
    remove_column :assets, :original_width
    remove_column :assets, :original_height
    remove_column :assets, :original_extension
  end
end
