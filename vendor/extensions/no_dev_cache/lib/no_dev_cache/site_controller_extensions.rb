module NoDevCache::SiteControllerExtensions
  def self.included(base)
    base.send :alias_method_chain, :set_cache_control, :dev_exclusion
  end
  
  def set_cache_control_with_dev_exclusion
    if (request.head? || request.get?) && @page.cache? && live?
      expires_in self.class.cache_timeout, :public => true, :private => false
    else
      expires_in nil, :private => true, "no-cache" => true
      headers['ETag'] = ''
    end
  end
  
end