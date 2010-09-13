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
  before_filter :require_member, 
    :only => [:show_members_only, :edit_account, :update_account, :edit_password, :update_password]
  
  def index
    expires_in 5.minutes, :public => true, :private => false
    @member = current_member
    @members = Member.paginate :page => params[:p], :per_page => 20
    @title = 'Members'
  end

  def show
    expires_in 5.minutes, :public => true, :private => false
    @member = Member.find(params[:id])
    @title = @member.company_name
    render :action => 'show_public'
  end

  def show_members_only
    @member = Member.find(params[:id])
    @messages = Message.wall(@member.id).paginate :page => params[:page], :per_page => 20
    @title = @member.profile_name
    render :action => 'show_theirs'
  end

  def new
    @member = Member.new
    @title = 'Register Your Company'
  end
 
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to '/membership/registration-successful'
    else
      @title = 'Register Your Company'
      render :action => 'new'
    end
  end
  
  def account
    if current_member
      @member = current_member
      @messages = Message.recent.paginate :page => params[:page], :per_page => 20
      @title = "News Feed"
    else
      redirect_to '/home' 
    end 
  end
  
  def edit_account
    @member = current_member
    @title = 'Edit Account'
  end
  
  def update_account
    @member = current_member
    if @member.update_attributes(params[:member]) 
      @member.update_attribute :logo, nil if @member.logo_delete.to_i == 1
      flash[:notice] = 'Account and profile successfully updated'
      redirect_to account_url
    else
      @title = 'Edit Account'
      render :action => 'edit_account'
    end
  end
  
  def change_password
    @member = current_member
    @title = 'Change Password'
  end
  
  def update_password
    @member = current_member
    if @member.update_attributes(params[:member]) 
      flash[:notice] = "Password successfully changed"
      redirect_to account_url
    else
      @title = 'Change Password'
      render :action => 'change_password'
    end
  end
  
  def search_auto_complete_data
    expires_in 5.minutes, :public => true, :private => false
    render :text => Member.active.find(:all, :order => 'name asc').collect { |m| 
      {
        :label => %{#{h(m.company_name)}<div style="display:none">#{h(m.tagline)} #{h(m.bio)} #{h(m.keywords)}</div>},
        :logo => %{<img src="#{m.logo(:small_thumb)}" />},
        :description => h(m.tagline), 
        :value => member_link(m)
      }
    }.sort {|a,b| a[:label] <=> b[:label]}.to_json
  end
  
  def at_auto_complete_data
    expires_in 5.minutes, :public => true, :private => false
    render :text => Member.active.find(:all, :order => 'name asc').collect { |m| 
      {
        :label => %{#{h(m.company_name)}<div style="display:none">#{h(m.tagline)} #{h(m.bio)} #{h(m.keywords)}</div>},
        :logo => %{<img src="#{m.logo(:small_thumb)}" />},
        :description => h(m.tagline), 
        :value => "@#{h(m.profile_name)}"
      }
    }.sort {|a,b| a[:label] <=> b[:label]}.to_json
  end
  
  private 
    
    def member_link(member)
      if current_member
        "/members-only/members/#{member.to_param}"
      else
        "/members/#{member.to_param}"
      end
    end
end
