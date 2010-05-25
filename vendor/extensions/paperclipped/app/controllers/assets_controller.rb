class AssetsController < ApplicationController

  no_login_required

  # delivers an asset indirectly so as not to block

  def show
    @asset = Asset.find(params[:id])
    response.headers['X-Accel-Redirect'] = @asset.asset.url
    response.headers["Content-Type"] = @asset.asset_content_type
    response.headers['Content-Disposition'] = "attachment; filename=#{@asset.asset_file_name}" 
    response.headers['Content-Length'] = @asset.asset_file_size
    render :nothing => true
  end
  
end
