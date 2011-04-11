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
        if role[1].to_i > 0
          performance.performance_roles << PerformanceRole.new(:role_id => Role.find(role[0]).id,
                                                               :quantity => role[1], 
                                                               :optional => params[:optionals].include?(role[0]))
        end
      end
      performance.save
    end
  end

end
