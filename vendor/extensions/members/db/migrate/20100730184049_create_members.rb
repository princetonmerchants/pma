class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :fax
      t.string :email
      t.integer :category_id
      t.string :website
      t.string :tagline
      t.text :bio
      t.text :keywords
      t.string :hours
      t.boolean :ecommerce
      t.boolean :gifts
      t.string :news_feed
      t.string :events_feed
      t.string :products_feed
      t.date :member_since
      t.date :membership_expires_on
      t.string :level
      t.string :billing_contact
      t.string :billing_phone
      t.string :billing_email
      t.string :status
      t.string :password
      t.string :logo_file_name
      t.string :logo_content_type
      t.integer :logo_file_size
      t.datetime :logo_updated_at
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
