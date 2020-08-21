require 'google/apis/sheets_v4'

class GSheets::SheetsService
  class << self
    SCOPE = 'https://www.googleapis.com/auth/spreadsheets'
    SPREADSHEET_ID = '1G-LUggXthl9aXk6LwpqJY2A4ItjYFHd_lk3Pp5GDi2g'

    def push_data
      sheets_service = set_auth
      # zoom_analytics(sheets_service)
      sendgrid_analytics(sheets_service)
      # facebook_analytics(sheets_service)
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
      current_data = get_current_data(sheets, 'Zoom!A2:G')
      reported_webinar_ids = current_data&.values&.map{|cd| cd[1]}
      zoom_stats = Analytics::ZoomService.get_webinar_full_stats(reported_webinar_ids&.last)
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: zoom_stats.map{|st| st.except(:webinar_uuid).values})
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Zoom!A1', value_range_object, value_input_option: 'RAW')
    end

    def sendgrid_analytics(sheets)
      current_data = get_current_data(sheets, 'Sendgrid!A2:G')&.values || []
      single_sends = Analytics::SendgridMarketingService.get_single_send

      analytics_stats = single_sends.map do |ss|
        ss_stats = Analytics::SendgridMarketingService.get_stats_by_single_send(ss[:id]).first[:stats]
        {
          id: ss[:id],
          name: ss[:name],
          send_at: (DateTime.parse(ss[:send_at]) rescue nil),
          delivered: ss_stats[:delivered],
          unique_opens: ss_stats[:unique_opens],
          unique_clicks: ss_stats[:unique_clicks],
          unsubscribes: ss_stats[:unsubscribes]
        }
      end

      current_ids = current_data&.map{|cd| cd[0]}

      analytics_stats.map(&:values).each do |av|
        current_data_index = current_ids.find_index(av[0])
        if current_data_index
          current_data[current_data_index] = av
        else
          current_data << av
        end
      end

      current_data.sort_by! { |cd| -(cd[2].to_i) }
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: current_data)
      sheets.update_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A2', value_range_object, value_input_option: 'RAW')
    end

    def facebook_analytics(sheets)
      response = Analytics::FacebookPageService.get_posts

      current_data = get_current_data(sheets, 'Facebook!A2:V').values || []

      facebook_analytics = response.dig(:posts, :data).map do |resp|
        row = []
        row << resp[:id]
        row << resp[:permalink_url]
        row << resp[:message]
        row << resp.dig(:attachments, :data)&.first&.dig(:media_type)&.titleize || 'Status'
        row << (DateTime.parse(resp[:created_time]) + 8.hours).strftime('%d/%m/%Y - %I:%M %p')
        resp.dig(:insights, :data).each do |ins|
          row << ins[:values].first[:value]
        end
        row
      end

      facebook_analytics.each do |fa|
        current_data.deep_dup.each_with_index do |cd, i|
          if cd.include? fa[0]
            current_data[i] = fa
            break
          else
            current_data << fa
            break
          end
        end
      end

      current_data.sort { |cd| -(DateTime.parse(cd[4]).to_i) }
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: facebook_analytics)
      sheets.update_spreadsheet_value(SPREADSHEET_ID, 'Facebook!A2', value_range_object, value_input_option: 'RAW')
    end

    def google_analytics(sheets)
      analytics = Analytics::GoogleAnalyticsService.get_data
      analytics.reports.each do |rp|
        case rp.column_header.dimensions
        when ["ga:socialNetwork"]
          sheet_name = 'Google Analytics(Social Network)!A3'
        when ["ga:campaign"]
          sheet_name = 'Google Analytics(Campaigns)!A3'
        end

        current_data = get_current_data(sheets, "#{sheet_name}:F").values || []
        new_data = rp.data.rows.map.with_index do |data, index|
          if index == 0
            date = "#{(Date.today - 7.days).strftime('%d/%m/%Y')} - #{Date.today.strftime('%d/%m/%Y')}"
            [date, data.dimensions.join(','), data.metrics.first.values].flatten
          else
            ["", data.dimensions.join(','), data.metrics.first.values].flatten
          end
        end

        new_data << Array.new(6, "")
        combined_data = new_data + current_data

        value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: combined_data)
        sheets.update_spreadsheet_value(SPREADSHEET_ID, sheet_name, value_range_object, value_input_option: 'RAW')
      end
    end

    def ig_analytics(sheets)
      current_data = get_current_data(sheets, 'Instagram!A2:J').values || []
      posts = Analytics::InstagramService.get_posts

      posts_stats = posts.dig(:media, :data)&.map do |ps|
        caption = ps[:caption] || ""

        if ps.dig(:insights, :data)
          insights = ps.dig(:insights, :data).map do |ins|
            ins.dig(:values)&.first&.dig(:value)
          end
        end

        [ps[:id], ps[:permalink], ps[:caption], (DateTime.parse(ps[:timestamp]) + 8.hours).strftime('%d/%m/%Y - %I:%M %p'), ps[:comments_count], ps[:like_count], ps[:comment_count]] + (insights || [])
      end

      posts_stats.each_with_index do |pss, index|
        if pss.first == current_data[index]&.first
          current_data[index] = pss
        else
          current_data << pss
        end
      end

      current_data.sort { |cd| -(DateTime.parse(cd[3]).to_i) }

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: posts_stats)
      sheets.update_spreadsheet_value(SPREADSHEET_ID, 'Instagram!A2', value_range_object, value_input_option: 'RAW')
    end
  end
end