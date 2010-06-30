namespace :radiant do
  namespace :extensions do
    namespace :no_dev_cache do
      
      desc "Runs the migration of the No Dev Cache extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          NoDevCacheExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          NoDevCacheExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the No Dev Cache to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from NoDevCacheExtension"
        Dir[NoDevCacheExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(NoDevCacheExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
