class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :from_member_id
      t.integer :to_member_id
      t.string :notifiable_type
      t.integer :notifiable_id
      t.boolean :seen, :default => false

      t.timestamps
    end
    
    add_column :members, :notify_me_when_others_post_on_my_wall, :boolean, :defaut => true
    add_column :members, :notify_me_when_others_respond, :boolean, :defaut => true
  end

  def self.down
    drop_table :notifications
    
    remove_column :members, :notify_me_when_others_post_on_my_wall
    remove_column :members, :notify_me_when_others_respond
  end
end
