class Admin::CategoriesController < ApplicationController  
  def index
    @categories = Category.paginate :page => params[:page], :per_page => 20
  end

  def new
    @category = Category.new
  end
 
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to categories_path
      flash[:notice] = "Category created."
    else
      flash[:error]  = "Category not created."
      render :action => 'new'
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category]) 
      redirect_to categories_path
      flash[:notice] = "Category edited."
    else
      flash[:error]  = "Category not edited."
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    if @category.members.empty?
      @category.destroy
      flash[:notice] = "Category deleted!"
    else
      flash[:notice] = "Category NOT deleted! First you must move its members elsewhere."
    end
    redirect_to categories_path
  end
end