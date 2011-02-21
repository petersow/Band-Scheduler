class RolesController < ApplicationController
  
  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def create
    Role.create!(params[:role])
    redirect_to roles_index_path
  end
 
end
