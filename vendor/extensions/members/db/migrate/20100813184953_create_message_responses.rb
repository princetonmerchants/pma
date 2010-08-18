class CreateMessageResponses < ActiveRecord::Migration
  def self.up
    create_table :message_responses do |t|
      t.text :body
      t.integer :member_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_responses
  end
end
