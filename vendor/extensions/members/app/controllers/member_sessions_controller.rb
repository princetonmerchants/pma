class MemberSessionsController < BaseController
  before_filter :require_no_member, :only => [:new, :create]
  before_filter :require_member, :only => :destroy
  
  def new
    @title  = 'Login'
    @member_session = MemberSession.new
    store_referer unless session[:retern_to]
  end
  
  def create
    @member_session = MemberSession.new(params[:member_session])
    if @member_session.save
      redirect_back_or_default account_url
    else
      @title  = 'Login'
      render :action => :new
    end
  end
  
  def destroy
    current_member_session.destroy
    redirect_back_or_default root_url
  rescue 
    redirect_back_or_default member_login_url
  end
  
  def logout_first
    @member = current_member
    @title = 'Logout First'
  end
end