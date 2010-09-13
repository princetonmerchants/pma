class MessagePosition < ActiveRecord::Migration
  def self.up
    add_column :message_members, :position, :integer
  end

  def self.down
    remove_column :message_members, :position
  end
end
