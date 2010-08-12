class BaseController < SiteController
  radiant_layout Radiant::Config['membership.layout']
  no_login_required
end
