class MessagesController < ApplicationController
  before_filter :require_member
  
  def show
    @message = Message.find(params[:id]) 
    @member = @message.member
  end
 
  def create
    @message = Message.new(params[:message])
    @message.member = current_member
    @member = current_member
    if @message.save
      if request.xhr? 
        render :partial => 'show', :locals => {:message => @message}, :layout => nil
      else
        redirect_back_or_default account_url        
      end
    else
      render :status => 500, :message => 'Message not saved!'
    end
  end

  def destroy
    current_member.messages.destroy(params[:id])
    if request.xhr? 
      render :text => params[:id]
    else
      redirect_back_or_default account_url
    end
  rescue
    render :status => 500, :message => 'Message not destroyed!'
  end
end
