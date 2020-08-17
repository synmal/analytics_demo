require 'google/apis/sheets_v4'

class GSheets::SheetsService

  class << self
    SCOPE = 'https://www.googleapis.com/auth/spreadsheets'
    SPREADSHEET_ID = '1G-LUggXthl9aXk6LwpqJY2A4ItjYFHd_lk3Pp5GDi2g'

    def push_data
      sheets_service = set_auth
      # zoom_analytics(sheets_service)
      sendgrid_analytics(sheets_service)
      # value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: generate_test)
      # sheets_service.append_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A1', value_range_object, value_input_option: 'RAW')
    end

    def set_auth
      _service = Google::Apis::SheetsV4::SheetsService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    # Temp
    def zoom_analytics(sheets)
      zoom_stats = Analytics::ZoomService.get_webinar_full_stats
      # zoom_stats = [{:topic=>"Create Your Own Commerce Platform For Free", :start_time=>"10 June 2020 - 1456 HRS", :end_time=>"10 June 2020 - 1556 HRS", :total_minutes=>348, :participants=>10}, {:topic=>"Exclusive Tips To Help Maximize Your Sales & ROI", :start_time=>"12 June 2020 - 1348 HRS", :end_time=>"12 June 2020 - 1526 HRS", :total_minutes=>1977, :participants=>37}, {:topic=>"Training On LazTalent", :start_time=>"12 June 2020 - 2047 HRS", :end_time=>"12 June 2020 - 2216 HRS", :total_minutes=>1330, :participants=>28}, {:topic=>"Test Webinar", :start_time=>"23 June 2020 - 1445 HRS", :end_time=>"23 June 2020 - 1504 HRS", :total_minutes=>85, :participants=>11}, {:topic=>"Rehearsal Live", :start_time=>"25 June 2020 - 1532 HRS", :end_time=>"25 June 2020 - 1647 HRS", :total_minutes=>543, :participants=>7}, {:topic=>"Summerie & Machine - Cantik & Bergaya Unboxing Surprise Box", :start_time=>"26 June 2020 - 1927 HRS", :end_time=>"26 June 2020 - 2113 HRS", :total_minutes=>681, :participants=>11}, {:topic=>"The Potential of Performance Based Influencer Marketing For Your Brands", :start_time=>"10 July 2020 - 1415 HRS", :end_time=>"10 July 2020 - 1553 HRS", :total_minutes=>2121, :participants=>35}, {:topic=>"Free Webinar: Special Intro & Walkthrough On IG Links Customization", :start_time=>"17 July 2020 - 1451 HRS", :end_time=>"17 July 2020 - 1623 HRS", :total_minutes=>1208, :participants=>27}, {:topic=>"The Rise of Live Streaming Trend & Where Does Malaysia Stand", :start_time=>"24 July 2020 - 1416 HRS", :end_time=>"24 July 2020 - 1550 HRS", :total_minutes=>1388, :participants=>29}, {:topic=>"The Solution To Maximize The Link In Bio For Your Brands!", :start_time=>"07 August 2020 - 1421 HRS", :end_time=>"07 August 2020 - 1459 HRS", :total_minutes=>196, :participants=>11}, {:topic=>"We Are Subsidising Your KOL Marketing Campaign!", :start_time=>"14 August 2020 - 1422 HRS", :end_time=>"14 August 2020 - 1503 HRS", :total_minutes=>243, :participants=>12}]
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: zoom_stats.map{|st| st.values})
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Zoom!A1', value_range_object, value_input_option: 'RAW')
    end

    def sendgrid_analytics(sheets)
      # Get data here
      single_send_ids = Analytics::SendgridMarketingService.get_single_send.map{|ss| {id: ss[:id], title: ss[:name]}}
      # single_send_ids = [{:id=>"840a294d-cd6e-11ea-8047-2698926af149", :title=>"SG test"}]
      analytics = single_send_ids.map{ |ss| Analytics::SendgridMarketingService.get_stats_by_single_send(ss[:id]) }.flatten
      # analytics = [{:ab_phase=>"all", :ab_variation=>"all", :aggregation=>"total", :stats=>{:bounce_drops=>0, :bounces=>0, :clicks=>4, :unique_clicks=>1, :delivered=>1, :invalid_emails=>0, :opens=>2, :unique_opens=>1, :requests=>1, :spam_report_drops=>0, :spam_reports=>0, :unsubscribes=>1}, :id=>"840a294d-cd6e-11ea-8047-2698926af149"}]
      analytics_stats = analytics.map.with_index{|as, index| 
        as[:stats].values.unshift(single_send_ids[index][:title])
      }

      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: analytics_stats)
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A1', value_range_object, value_input_option: 'RAW')
    end
  end
end