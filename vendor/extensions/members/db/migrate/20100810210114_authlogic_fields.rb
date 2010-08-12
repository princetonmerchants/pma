class AuthlogicFields < ActiveRecord::Migration
  def self.up
    rename_column :members, :name, :company_name
    rename_column :members, :address_1, :company_address_1
    rename_column :members, :address_2, :company_address_2
    rename_column :members, :city, :company_city
    rename_column :members, :state, :company_state
    rename_column :members, :zip, :company_zip
    rename_column :members, :phone, :company_phone
    rename_column :members, :fax, :company_fax
    rename_column :members, :email, :company_email
    rename_column :members, :admin_name, :name
    rename_column :members, :admin_email, :email
    rename_column :members, :admin_phone, :phone
    remove_column :members, :admin_password
    
    add_column :members, :crypted_password, :string
    add_column :members, :password_salt, :string
    add_column :members, :persistence_token, :string
    add_column :members, :login_count, :integer, :default => 0
    add_column :members, :last_request_at, :datetime
    add_column :members, :last_login_at, :datetime
    add_column :members, :current_login_at, :datetime
    add_column :members, :last_login_ip, :string
    add_column :members, :current_login_ip, :string
    
    add_index :members, :email
    add_index :members, :persistence_token
    add_index :members, :last_request_at
  end

  def self.down
    rename_column :members, :name, :admin_name
    rename_column :members, :email, :admin_email
    rename_column :members, :phone, :admin_phone 
    rename_column :members, :company_name, :name
    rename_column :members, :company_address_1, :address_1
    rename_column :members, :company_address_2, :address_2
    rename_column :members, :company_city, :city
    rename_column :members, :company_state, :state
    rename_column :members, :company_zip, :zip
    rename_column :members, :company_phone, :phone
    rename_column :members, :company_fax, :fax
    rename_column :members, :company_email, :email
    add_column :members, :admin_password, :string
    
    remove_column :members, :crypted_password
    remove_column :members, :password_salt
    remove_column :members, :persistence_token
    remove_column :members, :login_count
    remove_column :members, :last_request_at
    remove_column :members, :last_login_at
    remove_column :members, :current_login_at
    remove_column :members, :last_login_ip
    remove_column :members, :current_login_ip
    
    remove_index :members, :email
    remove_index :members, :persistence_token
    remove_index :members, :last_request_at
  end
end
