require 'google/apis/sheets_v4'

class GSheets::SheetsService
  class << self
    SCOPE = 'https://www.googleapis.com/auth/spreadsheets'
    SPREADSHEET_ID = '1G-LUggXthl9aXk6LwpqJY2A4ItjYFHd_lk3Pp5GDi2g'

    def push_data
      sheets_service = set_auth
      # GSheets::SheetsService.push_data
      # zoom_analytics(sheets_service)
      # sendgrid_analytics(sheets_service)
      facebook_analytics(sheets_service)
      # google_analytics(sheets_service)
      # ig_analytics(sheets_service)
    end

    private
    def set_auth
      _service = Google::Apis::SheetsV4::SheetsService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    def get_current_data(sheets, sheet_range)
      sheets.get_spreadsheet_values(SPREADSHEET_ID, sheet_range)
    end

    def zoom_analytics(sheets)
      ## COLUMNS
      # Topic | Webinar ID | Actual Start Time | Actual Duration (minutes) | # Registered | # Cancelled | Unique Viewers | Total Users | Max Concurrent Views | % Attended | Audience
      current_data = get_current_data(sheets, 'Zoom!A2:G')
      reported_webinar_ids = current_data&.values&.map{|cd| cd[1]}
      zoom_stats = Analytics::ZoomService.get_webinar_full_stats(reported_webinar_ids&.last)
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: zoom_stats.map{|st| st.except(:webinar_uuid).values})
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Zoom!A1', value_range_object, value_input_option: 'RAW')
    end

    def sendgrid_analytics(sheets)
      ## COLUMNS
      # Single Send ID | Single Send Name | Date | Delivered | Unique Opens | Unique Clicks | Unsubscribes
      current_data = get_current_data(sheets, 'Sendgrid!A2:G')
      last_reported_id = current_data&.values&.last&.first
      single_sends = Analytics::SendgridMarketingService.get_single_send

      if last_reported_id
        last_reported_index = single_sends.find_index{|ss| ss[:id]}
        single_sends = single_sends[(last_reported_index + 1)..]
      end

      analytics_stats = single_sends.map do |ss|
        ss_stats = Analytics::SendgridMarketingService.get_stats_by_single_send(ss[:id]).first[:stats]
        {
          id: ss[:id],
          name: ss[:name],
          send_at: (Date.parse(ss[:send_at]) rescue nil),
          delivered: ss_stats[:delivered],
          unique_opens: ss_stats[:unique_opens],
          unique_clicks: ss_stats[:unique_clicks],
          unsubscribes: ss_stats[:unsubscribes]
        }
      end

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: analytics_stats.map(&:values))
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A2', value_range_object, value_input_option: 'RAW')
    end

    def facebook_analytics(sheets)
      ## Columns
      # Post ID | Permalink | Post Message | Type | Countries | Languages | Posted | Audience Targeting | Lifetime Post Total Impressions | Lifetime Post Organic Impressions | Lifetime Post organic reach | Lifetime Post Paid Impressions | Lifetime Post Paid Reach | Lifetime Post Total Reach | Lifetime Engaged Users | Lifetime Negative Feedback | Lifetime People who have liked your Page and engaged with your post | Lifetime Average time video viewed | Lifetime Total Video View Time (in MS) | Lifetime Total Video Views | Lifetime Total 30-Second Views | Lifetime Organic 30-Second Views | Lifetime Paid 30-Second Views | Lifetime Paid Video Views | Lifetime Organic Video Views
      response = Analytics::FacebookPageService.get_posts
      facebook_analytics = response[:data].map do |resp|
        row = []
        row << resp[:permalink_url]
        row << resp[:message]
        resp.dig(:insights, :data).each do |ins|
          row << ins[:values].first[:value]
        end
        row
      end

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: facebook_analytics)
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Facebook!A1', value_range_object, value_input_option: 'RAW')
    end

    def google_analytics(sheets)
      ### ALL IN ALPHABET ORDER
      ## SOCIAL MEDIA
      # (not set) | Blogger | Facebook | Instagram | Instagram Stories | LinkedIn
      ## CAMPAIGN
      # cpc-inf-ecom-page-showcase | cpc-intro-in-sv | cpc-how-to-setup | PENJANAeCommerceMSME | Get Influencers To Sell Your Products For You
      analytics = Analytics::GoogleAnalyticsService.get_data
      analytics.reports.each do |rp|
        case rp.column_header.dimensions
        when ["ga:socialNetwork"]
          sheet_name = 'Google Analytics(Social Network)!A3'
        when ["ga:campaign"]
          sheet_name = 'Google Analytics(Campaigns)!A3'
        end

        data = rp.data.rows.map{ |dt| dt.metrics.map(&:values) }.flatten
        # byebug
        data.unshift("#{Date.today - 7.days} - #{Date.today}")
        value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [data])
        sheets.append_spreadsheet_value(SPREADSHEET_ID, sheet_name, value_range_object, value_input_option: 'RAW')
      end
    end

    def ig_analytics(sheets)
      posts = Analytics::InstagramService.get_posts
      posts_stats = posts.dig(:media, :data)&.map{|ps| ps.values}
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: posts_stats)
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Instagram!A1', value_range_object, value_input_option: 'RAW')
    end
  end
end