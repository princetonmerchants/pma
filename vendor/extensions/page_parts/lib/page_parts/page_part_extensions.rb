module PageParts
  module PagePartExtensions
    def self.included(base)
      base.class_eval do
        set_inheritance_column :page_part_type
        class_inheritable_accessor :content_column
        self.content_column = :content
        include Annotatable
        annotate :part_name
        part_name 'Text Area'
      end

      class << base
        # attributes hash can include :page_part_type => 'PagePartDescendentName'.
        # Returned object will be an instance of this class. If passed class is
        # _not_ a PagePart or PagePart descendant, returned object will be a normal
        # PagePart. If class name is not a valid constant, throws an exception.
        def new(attributes={})
          attributes.stringify_keys!
          if klass_name = attributes.delete('page_part_type') and (klass = klass_name.constantize) < PagePart
            klass.new(attributes)
          else
            super
          end
        end

        # For front-end transparency, @subclassed_page_part.becomes(PagePart)
        # will cast up to the base class and translate any native content to
        # a string using the render_content method.
        def inherited(subclass)
          subclass.part_name = subclass.name.to_name('Page Part')
          subclass.show_filters self.show_filters
          subclass.class_eval do
            def becomes(superclass)
              object = super
              object.content = render_content if object.respond_to?(:content=)
              object
            end
          end
        end

        # When defining new PagePart subclasses, use +content+ to set storage column.
        #
        #   class BooleanPagePart < PagePart
        #     content :boolean
        #   end
        def content(type)
          self.content_column = "#{type}_content"
          alias_attribute :content, self.content_column
        end
        alias_method :content=, :content

        # Filename of edit partial
        def partial_name
          'PagePart' == name ? 'text_page_part' : name.gsub(' ', '').underscore
        end

        # Workaround for ActiveRecord bug,
        # see https://rails.lighthouseapp.com/projects/8994/tickets/1339
        # For development & testing you may also need to change config/environment.rb from:
        #     config.time_zone = 'UTC'
        # to:
        #     config.active_record.default_timezone = :utc
        def scoped_methods
          Thread.current[:"#{self}_scoped_methods"] ||= (self.default_scoping || []).dup
        end

        def show_filters(show=nil)
          @show_filters = true unless instance_variable_defined? :@show_filters
          show.nil? ? @show_filters : @show_filters = show
        end

        def descendants
          load_descendants
          super
        end

        private

        def load_descendants
          unless @_descendants_loaded
            paths = [Rails, *Radiant::Extension.descendants].map do |ext|
              ext.root.to_s + '/app/models'
            end
            paths.each do |path|
              Dir["#{path}/*_page_part.rb"].each do |page_part|
                $1.camelize.constantize if page_part =~ %r{/([^/]+)\.rb}
              end
            end
            @_descendants_loaded = true
          end
        end
      end
    end

    def partial_name
      self.class.partial_name
    end

    # Override this to set up custom rendering
    def render_content
      content.to_s
    end

    def attributes=(attributes)
      attributes.stringify_keys!
      # passing a blank content attr tends to override the expected behavior
      # for subclasses. in cases where the content column is *explicitly* set,
      # remove the content attr if it is blank.
      attributes.delete('content') if attributes['content'].blank? && content_column && content_column != :content
      super
    end

    def show_filters?
      self.class.show_filters
    end
  end
end