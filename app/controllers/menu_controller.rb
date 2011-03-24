class MenuController < ApplicationController

  def index
    @date = params[:month] ? params[:month].to_date : Date.today
  end
end
