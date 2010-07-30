class CreateMemberCategories < ActiveRecord::Migration
  def self.up
    create_table :member_categories do |t|
      t.integer :member_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :member_categories
  end
end
