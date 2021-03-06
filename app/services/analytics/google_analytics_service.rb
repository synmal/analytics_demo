require 'google/apis/analyticsreporting_v4'
class Analytics::GoogleAnalyticsService
  class << self
    SCOPE = 'https://www.googleapis.com/auth/analytics.readonly'

    def get_data
      analytics = set_auth

      # date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '7DaysAgo', end_date: 'today')

      request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
        {
          report_requests: [
            generate_report_request(['ga:users', 'ga:newUsers', 'ga:sessions', 'ga:bounceRate'], ['ga:socialNetwork']),
            generate_report_request(['ga:users', 'ga:newUsers', 'ga:sessions', 'ga:bounceRate'], ['ga:campaign']),
          ]
        }
      )

      analytics.batch_get_reports(request)
    end
    
    def set_auth
      _service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    def generate_metric(metrics)
      metrics.map do |metric|
        Google::Apis::AnalyticsreportingV4::Metric.new(expression: metric)
      end
    end

    def generate_dimensions(dimensions)
      dimensions.map do |dim|
        Google::Apis::AnalyticsreportingV4::Dimension.new(name: dim)
      end
    end

    def generate_report_request(metrics, dimensions)
      Google::Apis::AnalyticsreportingV4::ReportRequest.new(
        view_id: '215727737',
        sampling_level: 'LARGE',
        metrics: generate_metric(metrics),
        dimensions: generate_dimensions(dimensions)
      )
    end
  end
end