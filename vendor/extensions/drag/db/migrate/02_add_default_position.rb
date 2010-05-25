class AddDefaultPosition < ActiveRecord::Migration
  def self.up
    change_column :pages, :position, :integer, :default => 0
    
    Page.all.each do |page|
      page.position = 0 if page.position.nil?
    end
  end
  
  def self.down
    change_column :pages, :position, :integer, :default => nil
  end
  
end