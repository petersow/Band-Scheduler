class PerformancesController < ApplicationController

  def index
    @performances = Performance.all
  end

  def new
    @performance = Performance.new
    @roles = Role.all
  end

  def create
    redirect_to performances_path
    if request.post?
      performance = Performance.new
      performance.save
      params[:roles].each do |role|
        pr = PerformanceRole.new 
        pr.role_id = Role.find(role[0]).id
        pr.performance_id = performance.id
        pr.quantity = role[1]
        pr.save
      end
    end
  end

end
