class Analytics::InstagramService
  class << self
    def get_posts
      response = get_ig_posts_with_insights
      if response[:error]
        response = get_ig_posts
      end
      response
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

    def get_ig_posts_with_insights
      fields = 'media.limit(100){id, permalink, comments_count, like_count, insights.metric(engagement,impressions,reach,saved,video_views)}'
      response = call(fields)
      parse_response(response)
    end

    def get_ig_posts
      fields = 'media.limit(100){id, permalink, comments_count, like_count}'
      response = call(fields)
      parse_response(response)
    end
  end
end