class Analytics::FacebookPageService
  class << self
    def get_posts
      fields = 'posts{id,message,insights.metric(post_engaged_users,post_clicks,post_clicks_unique,post_impressions,post_impressions_unique,post_reactions_by_type_total)}'
      response = call(fields)
      parse_response(response)
    end

    private
    def call(fields = '')
      Faraday.get("https://graph.facebook.com/v7.0/#{Rails.application.credentials.fb_page[:id]}") do |req|
        req.params['access_token'] = Rails.application.credentials.fb_page[:access_token]
        req.params['fields'] = fields
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end