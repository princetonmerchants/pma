class MembersController < BaseController
  radiant_layout Proc.new { |c| 
    if %w{ show_members_only show account }.include?(c.action_name)
      'ThreeColumns' 
    else 
      Radiant::Config['membership.layout']
    end
  }
  no_login_required
  before_filter :require_no_member, :only => [:new, :create]
  before_filter :require_member, :only => [:show_members_only, :account, :edit_account, :update_account]
  
  def index
    @member = current_member
    @members = Member.paginate :page => params[:p], :per_page => 20
    @title = 'Members'
  end

  def show
    @member = Member.find(params[:id])
    @title = @member.company_name
    render :action => 'show_public'
  end

  def show_members_only
    @member = Member.find(params[:id])
    @title = @member.company_name
    #if current_member_page?      
    #  render :action => 'show_mine'
    #else
      render :action => 'show_theirs'
    #end
  end

  def new
    @member = Member.new
    @title = 'Register'
  end
 
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to '/membership/registration-successful'
    else
      @title = 'Register'
      render :action => 'new'
    end
  end
  
  def account
    @member = current_member
    @title = "News Feed"
  end
  
  def edit_account
    @member = current_member
    @title = 'Edit account and profile'
  end
  
  def update_account
    @member = current_member
    if @member.update_attributes(params[:member]) 
      @member.update_attribute :logo, nil if @member.logo_delete.to_i == 1
      flash[:notice] = 'Account and profile successfully updated'
      redirect_to account_url
    else
      @title = 'Edit account and profile'
      render :action => 'edit_account'
    end
  end
end
