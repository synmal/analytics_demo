class Analytics::SendgridMarketingService
  class << self
    def get_single_send
      url = 'https://sendgrid.com/v3/marketing/singlesends'
      response = call(url)
      parse_response(response)[:result]
    end
  
    def get_stats_by_single_send(id)
      url = "https://sendgrid.com/v3/marketing/stats/singlesends/#{id}"
      response = call(url)
      parse_response(response)[:results]
    end
  
    private
    def call(url)
      Faraday.get(url) do |req|
        req.headers['Authorization'] = "Bearer #{Rails.application.credentials.sendgrid[:api_key]}"
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end