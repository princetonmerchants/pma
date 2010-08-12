class PasswordResetsController < BaseController
  before_filter :load_member_using_persistence_token, :only => [:edit, :update]
  before_filter :require_no_member, :except => [:edit, :update]
  
  def new
    @title = 'Password Reset Request'
  end
  
  def create
    if @member = Member.find_by_email(params[:email])
      @member.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you."
      redirect_to member_login_path
    else
      @title = 'Password Reset Request'
      flash[:notice] = "No member was found with that email address"
      render :action => :new
    end
  end
  
  def edit
    @title = 'Change Password'
  end

  def update
    @member.password = params[:member][:password]
    @member.password_confirmation = params[:member][:password_confirmation]
    if @member.save
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      @title = 'Change Password'
      render :action => :edit
    end
  end

  private
    def load_member_using_persistence_token      
      unless @member = Member.find_by_persistence_token(params[:id])
        flash[:notice] = "We're sorry, but we could not locate your account. " +
          "Try copying/pasting the URL from your email into your browser or restarting the " +
          "reset password process."
        redirect_to password_reset_path
      end
    end
end