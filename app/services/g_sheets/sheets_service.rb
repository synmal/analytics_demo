require 'google/apis/sheets_v4'

class GSheets::SheetsService

  class << self
    SCOPE = 'https://www.googleapis.com/auth/spreadsheets'
    SPREADSHEET_ID = '1G-LUggXthl9aXk6LwpqJY2A4ItjYFHd_lk3Pp5GDi2g'

    def push_data
      sheets_service = set_auth
      # zoom_analytics(sheets_service)
      # sendgrid_analytics(sheets_service)
      # facebook_analytics(sheets_service)
      google_analytics(sheets_service)
      # ig_analytics(sheets_service)
    end

    private
    def set_auth
      _service = Google::Apis::SheetsV4::SheetsService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    def zoom_analytics(sheets)
      zoom_stats = Analytics::ZoomService.get_webinar_full_stats
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: zoom_stats.map{|st| st.values})
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Zoom!A1', value_range_object, value_input_option: 'RAW')
    end

    def sendgrid_analytics(sheets)
      single_send_ids = Analytics::SendgridMarketingService.get_single_send.map{|ss| {id: ss[:id], title: ss[:name]}}
      analytics = single_send_ids.map{ |ss| Analytics::SendgridMarketingService.get_stats_by_single_send(ss[:id]) }.flatten
      analytics_stats = analytics.map.with_index{|as, index| 
        as[:stats].values.unshift(single_send_ids[index][:title])
      }

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: analytics_stats)
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A1', value_range_object, value_input_option: 'RAW')
    end

    def facebook_analytics(sheets)
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

orders.as_json(only: [:cart_order_code, :transactions_status]).filter {|a| a['transactions_status'] != 20 }