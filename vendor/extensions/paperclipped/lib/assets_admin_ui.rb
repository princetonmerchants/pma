module AssetsAdminUI

 def self.included(base)
   base.class_eval do

      attr_accessor :asset
      alias_method :assets, :asset
      
      protected

        def load_default_asset_regions
          returning OpenStruct.new do |asset|
            asset.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_title edit_extended_metadata edit_content}
              edit.form_bottom.concat %w{edit_buttons edit_timestamp}
            end
            asset.new = asset.edit
            asset.index = Radiant::AdminUI::RegionSet.new do |index|
              index.preamble.concat %w{header explanation new_button filters}
              index.assets_container
              index.bottom.concat %w{regenerate}
              index.thead.concat %w{thumbnail_header title_header content_type_header modify_header}
              index.tbody.concat %w{thumbnail_cell title_cell content_type_cell bucket_cell remove_cell}
              index.bucket_pane.concat %w{bucket_notes bucket bucket_bottom}
              index.asset_tabs.concat %w{search_tab}
              index.paginate
            end
            asset.remove = asset.index
          end
        end
      
    end
  end
end

