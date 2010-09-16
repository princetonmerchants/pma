class MoreEmailNotificationPreferences < ActiveRecord::Migration
  def self.up
    add_column :members, :notify_me_when_articles_are_posted, :boolean, :defaut => true
    add_column :members, :notify_me_when_featured_events_are_posted, :boolean, :defaut => true
    add_column :members, :notify_me_when_resources_are_posted, :boolean, :defaut => true
  end

  def self.down
    remove_column :members, :notify_me_when_articles_are_posted
    remove_column :members, :notify_me_when_featured_events_are_posted
    remove_column :members, :notify_me_when_resources_are_posted
  end
end
