class Analytics::SendgridController < ApplicationController
  def show
    params = {
      aggregated_by: 'day',
      start_date: (Date.today - 3.years + 1.day).strftime
    }

    # Global
    @response = JSON.parse(Sg.client.stats.get(query_params: params).body, symbolize_names: true)
  end
end
