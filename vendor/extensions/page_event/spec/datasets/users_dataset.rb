class UsersDataset < Dataset::Base
  def load
    create_record :user, :not, :name => 'Notadmin', :password => 'radiant'
  end
end