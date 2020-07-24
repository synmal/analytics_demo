class Analytics::SendgridSingleSendsController < ApplicationController
  def index
    @single_sends = Analytics::SendgridMarketingService.get_single_send
  end

  def show
    @single_send = Analytics::SendgridMarketingService.get_stats_by_single_send(params[:id])
  end
end
