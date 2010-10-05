class CacheDependency < ActiveRecord::Base
  belongs_to :cache_dependable, :polymorphic => true
  belongs_to :page
end
