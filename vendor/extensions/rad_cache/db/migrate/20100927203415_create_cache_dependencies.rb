class CreateCacheDependencies < ActiveRecord::Migration
  def self.up
    create_table :cache_dependencies do |t|
      t.integer :cache_dependable_id
      t.string :cache_dependable_type
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cache_dependencies
  end
end
