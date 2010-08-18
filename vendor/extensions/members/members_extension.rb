# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class MembersExtension < Radiant::Extension
  version "1.0"
  description "Members with registration, profiles, and members-only walls"
  url "http://www.comsoft155.com/"
  
  extension_config do |config|
    config.gem 'authlogic'
    config.gem 'state_machine'
  end
  
  def activate
    tab 'Membership' do
      add_item "Members", "/admin/members"
      add_item "Categories", "/admin/categories"
    end
    
    ApplicationController.class_eval do
      helper_method :current_member_session, :current_member, :current_member_page?
      filter_parameter_logging :password, :password_confirmation
    
      private
        def current_member_session
          return @current_member_session if defined?(@current_member_session)
          @current_member_session = MemberSession.find
        end
    
        def current_member
          return @current_member if defined?(@current_member)
          @current_member = current_member_session && current_member_session.member
        end
        
        def require_member
          unless current_member
            store_location
            flash[:notice] = "You must be logged in to access this page"
            redirect_to new_member_session_url
            return false
          end
        end
    
        def require_no_member
          if current_member
            store_location
            redirect_to member_logout_first_url
            return false
          end
        end
        
        def store_referer
          session[:return_to] = request.referer
        end
        
        def store_location
          session[:return_to] = request.request_uri
        end
        
        def redirect_back_or_default(default)          
          if %w{ logout-first login logout home }.include?(session[:return_to].to_s.split('/').last)
            redirect_to root_url
          else
            redirect_to(session[:return_to] || default)
          end
          session[:return_to] = nil
        end
        
        def current_member_page?
          true if current_member and @member and current_member.id == @member.id
        end
    end  
  end
end
