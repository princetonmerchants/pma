class Admin::MembersController < ApplicationController  
  def index
    @members = Member.find :all, :order => 'company_name asc'
  end

  def new
    @member = Member.new
  end
 
  def create
    @member = Member.new(params[:member])
    if @member.save(false)
      redirect_to admin_members_path
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
      redirect_to admin_members_path
      flash[:notice] = "Member edited."
    else
      flash[:error]  = "Member not edited."
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
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:notice] = "Member deleted!"
    redirect_to admin_members_path
  end
  
  def activate
    @member = Member.find(params[:id])
    @member.activate!
    flash[:notice] = "Member #{@member.name} was activated!"
    redirect_to admin_members_path
  end
  
  def deactivate
    @member = Member.find(params[:id])
    @member.deactivate!
    flash[:notice] = "Member #{@member.name} was deactivated!"
    redirect_to admin_members_path
  end
  
  def deny
    @member = Member.find(params[:id])
    @member.deny!
    flash[:notice] = "Member #{@member.name} was denied!"
    redirect_to admin_members_path
  end
end