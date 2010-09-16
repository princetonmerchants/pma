class NotificationsController < BaseController
  radiant_layout Proc.new { |c| 
    if %w{ index }.include?(c.action_name)
      'ThreeColumns' 
    elsif %w{ more quick_look page_seen }.include?(c.action_name)
      'Blank' 
    else 
      Radiant::Config['membership.layout']
    end
  }
  no_login_required
  before_filter :require_member
  
  def index
    @member = current_member
    @notifications = @member.notifications.find :all, :limit => 20
    @more_notifications_exist = @member.notifications.count > 20
    @title = 'Notifications'
  end

  def more
    @member = current_member
    @notifications = @member.notifications.paginate :page => params[:page], :per_page => 20
    @more_notifications_exist = (@member.notifications.count - ((20 * params[:page].to_i) - 20 + 1)) > 0
  end
  
  def quick_look
    @notifications_unseen = current_member.notifications.unseen.count
    @notifications = current_member.notifications.latest.find :all, :limit => 5
  end
  
  def page_seen
    Page.find_by_url(params[:page_url]).seen_by!(current_member.id)
    render :text => ''
  end
end
