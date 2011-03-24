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
      performance = Performance.new(params[:performance])
      params[:roles].each do |role|
        performance.performance_roles << PerformanceRole.new(:role_id => Role.find(role[0]).id,
                                                             :quantity => role[1])
      end
      performance.save
    end
  end

end
