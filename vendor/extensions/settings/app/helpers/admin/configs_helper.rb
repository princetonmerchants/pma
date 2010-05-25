module Admin::ConfigsHelper
  def render_node(key, object, options = {})
    @depth ||= 0
    
    if object.is_a?(Radiant::Config)
      render :partial => 'config', :locals => { :key => key, :conf => object, :hash => nil }
    else
      render :partial => 'config', :locals => { :key => key, :conf => nil, :hash => object }
    end
  end
end
