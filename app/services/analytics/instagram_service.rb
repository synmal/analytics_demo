class Analytics::InstagramService
  class << self
    def get_posts
      fields = 'website,insights.metric(website_clicks).period(day)'
      response = call(fields)
      parse_response(response)
    end

    private
    def call(fields = '')
      Faraday.get("https://graph.facebook.com/v7.0/#{Rails.application.credentials.instagram[:id]}") do |req|
        req.params['access_token'] = Rails.application.credentials.instagram[:access_token]
        req.params['fields'] = fields
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end