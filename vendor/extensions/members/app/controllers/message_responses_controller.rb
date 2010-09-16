class MessageResponsesController < ApplicationController
  before_filter :require_member
  no_login_required
  
  def show
    if MessageResponse.exists?(params[:id])
      @message_response = MessageResponse.find(params[:id])
      redirect_to @message_response.message
    else
      redirect_to '/page-not-found'
    end
  end
 
  def create
    @message_response = MessageResponse.new(params[:message_response])
    @message_response.member = current_member
    @member = current_member
    if @message_response.save
      if request.xhr? 
        render :partial => 'show', :locals => {:message_response => @message_response}, :layout => nil
      else
        redirect_back_or_default account_url        
      end
    else
      render :status => 500, :message_response => 'Response not saved!'
    end
  end

  def destroy
    current_member.responses.destroy(params[:id])
    if request.xhr? 
      render :text => params[:id]
    else
      redirect_back_or_default account_url
    end
  rescue
    render :status => 500, :message_response => 'Response not destroyed!'
  end
end
