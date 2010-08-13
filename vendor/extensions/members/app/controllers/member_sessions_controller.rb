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
    if session[:return_to].include('/logout-first') 
      redirect_back_or_default root_url
    else
      redirect_to :back
    end
  rescue 
    redirect_back_or_default member_login_url
  end
  
  def logout_first
    @member = current_member
    @title = 'Logout First'
  end
  
  def current_member_js
    if current_member
      render :text => %{ 
          var current_member = { 
              authenticated:true, 
              name:'#{current_member.name}, #{current_member.company_name}',
              profile_url:'#{member_url(current_member)}', 
              logo_tiny:'#{current_member.logo(:tiny)}',
              logo_thumb:'#{current_member.logo(:thumb)}',
              logo_small:'#{current_member.logo(:small)}',
              logo_normal:'#{current_member.logo(:normal)}',
              logo_large:'#{current_member.logo(:large)}',
              logo_original:'#{current_member.logo(:original)}'
            }
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
        }
    else
      render :text => %{ 
          var current_member = { authenticated:false, name:'Visitor', profile_url:'' }
          $('.current-member-name').html(current_member['name']);  
          $('a.current-member-profile').hide();  
          $('a.current-member-logo').hide(); 
          $('.members-only').hide();
          $('.visitors-only').show(); 
        }
    end
  end
end