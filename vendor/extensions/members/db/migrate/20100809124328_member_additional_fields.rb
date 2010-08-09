class MemberAdditionalFields < ActiveRecord::Migration
  def self.up
    add_column :members, :admin_name, :string
    add_column :members, :admin_email, :string
    add_column :members, :admin_phone, :string
    add_column :members, :admin_password, :string
    remove_column :members, :password
    add_column :members, :parent_property_id, :integer
    rename_column :members, :billing_contact, :billing_name
    add_column :members, :category_other, :string
  end

  def self.down
    remove_column :members, :admin_name
    remove_column :members, :admin_email
    remove_column :members, :admin_phone
    remove_column :members, :admin_password
    add_column :members, :password, :string
    remove_column :members, :parent_property_id
    rename_column :members, :billing_name, :billing_contact
    remove_column :members, :category_other
  end
end
