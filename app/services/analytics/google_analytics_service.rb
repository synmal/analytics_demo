require 'google/apis/analyticsreporting_v4'
class Analytics::GoogleAnalyticsService
  class << self
    SCOPE = 'https://www.googleapis.com/auth/analytics.readonly'
    METRICS = [
      'ga:users',
      'ga:newUsers',
      'ga:sessions',
      'ga:bounces',
      'ga:bounceRate',
      'ga:pageviews',
      'ga:hits',
      'ga:organicSearches'
    ]

    def get_data
      analytics = set_auth

      date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '7DaysAgo', end_date: 'today')

      request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
        report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
          view_id: '215727737',
          metrics: generate_metric,
          date_ranges: [date_range]
        )]
      )

      response = analytics.batch_get_reports(request)
    end
    
    def set_auth
      _service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    def generate_metric
      METRICS.map do |metric|
        Google::Apis::AnalyticsreportingV4::Metric.new(expression: metric)
      end
    end
  end
end