# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class RadCacheExtension < Radiant::Extension
  version "1.0"
  description "Caches pages to memcached. Observes pages, layouts, snippets, and comments in order to expire caches."
  url "http://comsoft155.com/rad_cache"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end
  
  def activate        
    Layout.class_eval do 
      has_many :cache_dependencies, :as => :cache_dependable, :dependent => :destroy
      has_many :cache_dependency_pages, :through => :cache_dependencies, 
        :class_name => 'Page', :source => :page, :uniq => true
      
      after_destroy Proc.new {Rails.cache.clear}
      
      def clear_cache!
        page_ids = cache_dependency_page_ids
        page_ids.each {|i| Rails.cache.delete("Page-#{i}")}
      end
    end
    
    Snippet.class_eval do 
      has_many :cache_dependencies, :as => :cache_dependable, :dependent => :destroy
      has_many :cache_dependency_pages, :through => :cache_dependencies, 
        :class_name => 'Page', :source => :page, :uniq => true
        
      after_create Proc.new {Rails.cache.clear}
      after_destroy Proc.new {Rails.cache.clear}
      
      def clear_cache!
        page_ids = cache_dependency_page_ids
        page_ids.each {|i| Rails.cache.delete("Page-#{i}")}
      end
    end
  
    Page.class_eval do 
      has_many :cache_dependencies, :as => :cache_dependable, :dependent => :destroy
      has_many :cache_dependency_pages, :through => :cache_dependencies, 
        :class_name => 'Page', :source => :page, :uniq => true
        
      after_destroy Proc.new {Rails.cache.clear}
      before_save Proc.new {|m| Rails.cache.clear if m.status_id_changed? and m.status_id == 100}
      
      def process(request, response)
        @request, @response = request, response
        if layout
          content_type = layout.content_type.to_s.strip
          @response.headers['Content-Type'] = content_type unless content_type.empty?
        end
        headers.each { |k,v| @response.headers[k] = v }
        if response_body = get_cache
          @response.body = response_body
        else
          @response.body = render
          set_cache(@response.body)
        end
        @response.status = response_code
      end
    
      def parse_object(object)
        current_page_id = @context.nil? ? self[:id] : @context.page.id
        object2 = object.is_a?(PagePart) ? object.page : object
        if object2.respond_to?(:cache_dependencies) and 
        not object2.cache_dependencies.exists?(['page_id = ?', current_page_id])
          object2.cache_dependencies.create :page_id => current_page_id
        end
        text = object.content
        text = parse(text)
        text = object.filter.filter(text) if object.respond_to? :filter_id
        text
      end
      
      def get_cache
        if caches = Rails.cache.fetch(page_cache_key)
          caches[request_cache_key]
        end
      end
      
      def set_cache(body)
        unless caches = Rails.cache.fetch(page_cache_key)
          caches = {}
        end
        caches[request_cache_key] = body
        Rails.cache.write(page_cache_key, caches)
      end
      
      def page_cache_key
        "Page-#{id}"
      end
      
      def request_cache_key
        path = @request.path.last == '?' ? @request.path[0..-1-1] : @request.path
        path = path.last == '/' ? path[0..-1-1] : path
        "#{path}-#{@request.query_string}"
      end
      
      def clear_cache!
        page_ids = cache_dependency_page_ids
        page_ids << id 
        page_ids << children.collect(&:id)
        page_ids.each {|i| Rails.cache.delete("Page-#{i}")}
      end
    end
    
    Comment.class_eval do 
      after_save :clear_cache!
      after_destroy :clear_cache!
      
      def clear_cache!
        page.clear_cache! if page
      end
    end
    
    Admin::ResourceController.class_eval do
      def clear_model_cache
        model.clear_cache! if model.respond_to?(:clear_cache!)
      end
    end
    
    SiteController.class_eval do
      def self.cache_timeout
        0
      end
    end
  end
end
