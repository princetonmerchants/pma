class BaseController < SiteController
  radiant_layout Radiant::Config['membership.layout']
  no_login_required
  helper :all
end
