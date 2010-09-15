class MembersController < BaseController
  radiant_layout Proc.new { |c| 
    if %w{ show_members_only show account }.include?(c.action_name)
      'ThreeColumns' 
    elsif %w{ notifications others_more_messages account_more_messages }.include?(c.action_name)
      'Blank' 
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
    @messages = Message.wall(@member.id).find(:all, :limit => 10)
    @more_messages_exist = Message.wall(@member.id).count >= 11
    @title = @member.company_name
    render :action => 'show_theirs'
  end  
  
  def others_more_messages
    @member = Member.find(params[:id])
    @messages = Message.wall(@member.id).paginate :page => params[:page], :per_page => 10
    @more_messages_exist = (Message.wall(@member.id).count - ((10 * params[:page].to_i) - 10 + 1)) > 0
    render :partial => 'more_messages'
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
      @messages = Message.recent.find(:all, :limit => 10)
      @more_messages_exist = Message.recent.count >= 11
      @title = "News Feed"
    else
      redirect_to '/home' 
    end 
  end
  
  def account_more_messages
    @member = current_member
    @messages = Message.recent.paginate :page => params[:page], :per_page => 10
    @more_messages_exist = (Message.recent.count - ((10 * params[:page].to_i) - 10 + 1)) > 0
    render :partial => 'more_messages'
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
  
  def current_member_json
    if current_member
      render :text => %{ 
          $(document).ready(function () {  
            current_member = { 
                authenticated:true, 
                id:#{current_member.id},
                name:'#{current_member.name}, #{current_member.company_name}',
                profile_url:'#{member_url(current_member)}', 
                logo_tiny:'#{current_member.logo(:tiny)}',
                logo_thumb:'#{current_member.logo(:thumb)}',
                logo_small:'#{current_member.logo(:small)}',
                logo_normal:'#{current_member.logo(:normal)}',
                logo_large:'#{current_member.logo(:large)}',
                logo_original:'#{current_member.logo(:original)}'
              }
            var form_authenticity_token = '#{form_authenticity_token}';
            $('.current-member-name').html(current_member['name']);
            $('a.current-member-profile').attr('href', current_member['profile_url']);
            $('a.current-member-profile').show();  
            $('.current-member-logo').attr('title', current_member['name']);
            $('.current-member-logo').attr('alt', current_member['name']);
            $('.current-member-logo tiny').attr('src', current_member['logo_tiny']);
            $('.current-member-logo thumb').attr('src', current_member['logo_thumb']);
            $('.current-member-logo small').attr('src', current_member['logo_small']);
            $('.current-member-logo normal').attr('src', current_member['logo_normal']);
            $('.current-member-logo large').attr('src', current_member['logo_large']);
            $('.current-member-logo original').attr('src', current_member['logo_original']);
            $('.members-only').show(); 
            $('.visitors-only').hide(); 
          });
        }
    else
      render :text => %{ 
          $(document).ready(function () {   
            current_member = { 
                authenticated:false, 
                name:'Visitor',
                id:-1,
                profile_url:'', 
                logo_tiny:'',
                logo_thumb:'',
                logo_small:'',
                logo_normal:'',
                logo_large:'',
                logo_original:''
              }
            var form_authenticity_token = '#{form_authenticity_token}';
            $('.current-member-name').html(current_member['name']);  
            $('a.current-member-profile').hide();  
            $('a.current-member-logo').hide(); 
            $('.members-only').hide();
            $('.visitors-only').show();
          });
        }
    end
  end  
  
  def notifications
    @notifications = current_member.notifications.latest
  end
  
  def search_auto_complete_json
    expires_in 5.minutes, :public => true, :private => false
    render :text => Member.active.collect { |m| 
      {
        :label => %{#{h(m.company_name)}<div style="display:none">#{h(m.tagline)} #{h(m.bio)} #{h(m.keywords)}</div>},
        :logo => %{<img src="#{m.logo(:small_thumb)}" />},
        :description => h(m.tagline), 
        :value => member_link(m)
      }
    }.to_json
  end
  
  def at_auto_complete_json
    expires_in 5.minutes, :public => true, :private => false
    render :text => Member.active.collect { |m| 
      {
        :label => %{#{h(m.company_name)}<div style="display:none">#{h(m.tagline)} #{h(m.bio)} #{h(m.keywords)}</div>},
        :logo => %{<img src="#{m.logo(:small_thumb)}" />},
        :description => h(m.tagline), 
        :value => "@#{h(m.profile_name)}"
      }
    }.to_json
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
