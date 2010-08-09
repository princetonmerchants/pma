class MembersController < SiteController
  radiant_layout Radiant::Config['membership.layout']
  no_login_required
  
  def index
    @members = Member.paginate :page => params[:p], :per_page => 20
    @title = 'Members'
  end

  def show
    @member = Member.find(params[:id])
    @title = @member.name
  end

  def new
    @member = Member.new
    @title = 'New Member Registration'
  end
 
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to '/membership/after-member-regristration'
    else
      @title = 'New Member Registration'
      render :action => 'new'
    end
  end
  
  def edit
    @member = Member.find(params[:id])
    @title = 'Edit account and profile'
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member]) 
      @member.update_attribute :logo, nil if @member.logo_delete.to_i == 1
      redirect_to @member
    else
      @title = 'Edit account and profile'
      render :action => 'edit'
    end
  end
  
  def edit_password
    @member = Member.find(params[:id])
  end
  
  def update_password
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member]) 
      redirect_to edit_admin_member_path(@member.id)
      flash[:notice] = "Member password edited."
    else
      flash[:error]  = "Member password not edited."
      render :action => 'edit_password'
    end
  end
end
