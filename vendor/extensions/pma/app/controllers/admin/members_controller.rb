class Admin::MembersController < ApplicationController  
  def index
    @members = Member.paginate :page => params[:page], :per_page => 20
  end

  def new
    @member = Member.new
  end
 
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to members_path
      flash[:notice] = "Member created."
    else
      flash[:error]  = "Member not created."
      render :action => 'new'
    end
  end
  
  def edit
    @member = Member.find(params[:id])
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member]) 
      @member.update_attribute :logo, nil if @member.logo_delete.to_i == 1
      redirect_to members_path
      flash[:notice] = "Member edited."
    else
      flash[:error]  = "Member not edited."
      render :action => 'edit'
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = "Member deleted!"
    redirect_to members_path
  end
  
  def activate
    @member = Member.find(params[:id])
    @member.activate!
    flash[:notice] = "Member #{@member.name} has been activated!"
    redirect_to members_path
  end
  
  def deactivate
    @member = Member.find(params[:id])
    @member.deactivate!
    flash[:notice] = "Member #{@member.name} has been deactivated!"
    redirect_to members_path
  end
end