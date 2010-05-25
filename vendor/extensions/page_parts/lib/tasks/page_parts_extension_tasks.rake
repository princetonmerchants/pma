namespace :radiant do
  namespace :extensions do
    namespace :page_parts do
      
      desc "Runs the migration of the Page Parts extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PagePartsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PagePartsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Page Parts to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PagePartsExtension"
        Dir[PagePartsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PagePartsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
