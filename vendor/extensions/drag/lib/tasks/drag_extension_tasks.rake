namespace :radiant do
  namespace :extensions do
    namespace :drag do
      
      desc "Runs the migration of the Drag extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          DragExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          DragExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Drag to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[DragExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(DragExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
