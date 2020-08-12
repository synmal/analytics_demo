class Analytics::FacebookPageService
  LIFETIME_INSIGHTS = [
    'post_engaged_users',
    'post_negative_feedback',
    'post_negative_feedback_unique',
    # 'post_negative_feedback_by_type_unique',
    'post_clicks',
    'post_clicks_unique',
    'post_engaged_fan',
    # 'post_clicks_by_type',
    # 'post_clicks_by_type_unique',
    'post_impressions',
    'post_impressions_unique',
    'post_impressions_paid',
    # 'post_impressions_paid_unique',
    # 'post_impressions_fan',
    # 'post_impressions_fan_unique',
    # 'post_impressions_fan_paid',
    # 'post_impressions_fan_paid_unique',
    'post_impressions_organic',
    'post_impressions_organic_unique',
    # 'post_impressions_viral',
    # 'post_impressions_viral_unique',
    # 'post_impressions_nonviral',
    # 'post_impressions_nonviral_unique',
    # 'post_impressions_by_story_type',
    # 'post_impressions_by_story_type_unique',
    'post_reactions_by_type_total'
  ]

  class << self
    def get_posts
      fields = "message,attachments,insights.metric(#{LIFETIME_INSIGHTS.join(',')}){name, values}"
      response = call(fields)
      parse_response(response)
    end

    private
    def call(fields = '')
      Faraday.get("https://graph.facebook.com/v7.0/#{Rails.application.credentials.fb_page[:id]}/feed") do |req|
        req.params['access_token'] = Rails.application.credentials.fb_page[:page_access_token]
        req.params['fields'] = fields
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end

=begin
pp Analytics::FacebookPageService.get_posts
=end