class DelayedEmailNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :email_delivered_at, :datetime
  end

  def self.down
    remove_column :notifications, :email_delivered_at
  end
end
