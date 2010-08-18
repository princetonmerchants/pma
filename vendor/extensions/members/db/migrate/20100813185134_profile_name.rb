class ProfileName < ActiveRecord::Migration
  def self.up
    add_column :members, :profile_name, :string
    Member.all.each do |member|
      member.update_attribute :profile_name, member.company_name.strip.downcase.gsub(/[^a-z0-9]/, '')
    end
  end

  def self.down
    remove_column :members, :profile_name
  end
end
