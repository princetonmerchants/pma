class AtWalls < ActiveRecord::Migration
  def self.up
    add_column :message_members, :at_wall, :boolean, :default => false
  end

  def self.down
    remove_column :message_members, :at_wall
  end
end
