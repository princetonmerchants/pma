class CreateMessageMembers < ActiveRecord::Migration
  def self.up
    create_table :message_members do |t|
      t.integer :member_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_members
  end
end
