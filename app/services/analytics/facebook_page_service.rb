class Analytics::FacebookPageService
  LIFETIME_INSIGHTS = [
    'post_impressions',
    'post_impressions_organic',
    'post_impressions_organic_unique',
    'post_impressions_paid',
    'post_impressions_paid_unique',
    'post_impressions_unique',
    'post_engaged_users',
    'post_negative_feedback',
    'post_engaged_fan',
    'post_video_avg_time_watched',
    'post_video_view_time',
    'post_video_views',
    'post_video_complete_views_30s_autoplayed',
    'post_video_complete_views_30s_organic',
    'post_video_complete_views_30s_paid',
    'post_video_views_paid',
    'post_video_views_organic'
  ]

  class << self
    def get_posts
      fields = "posts.limit(100){id,permalink_url,message,attachments{media_type,target},created_time,insights.metric(#{LIFETIME_INSIGHTS.join(',')}).period(lifetime){name, values}}"
      response = call(fields)
      parse_response(response.body)
    end

    private
    def call(fields = '')
      Faraday.get("https://graph.facebook.com/v8.0/#{Rails.application.credentials.fb_page[:id]}") do |req|
        req.params['access_token'] = Rails.application.credentials.fb_page[:page_access_token]
        req.params['fields'] = fields
        req.headers['Content_Type'] = "application/json"
      end
    end

    def parse_response(response)
      JSON.parse(response, symbolize_names: true)
    end
  end
end