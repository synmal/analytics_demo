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
      analytics = Analytics::GoogleAnalyticsService.get_data
      analytics_stats = analytics.reports.first.data.totals.first.values
      analytics_stats.unshift("#{(Date.today - 7.days).strftime('%d %B %Y')} - #{Date.today.strftime('%d %B %Y')}")
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [analytics_stats])
      sheets.append_spreadsheet_value(SPREADSHEET_ID, 'Google Analytics!A1', value_range_object, value_input_option: 'RAW')
    end

    def dummy_data
      {:data=>
        [{:permalink_url=>
           "https://www.facebook.com/109726977412856/posts/153221506396736/",
          :attachments=>
           {:data=>
             [{:media=>
                {:image=>
                  {:height=>524,
                   :src=>
                    "https://scontent.fkul15-1.fna.fbcdn.net/v/t1.0-9/s720x720/117375534_153221469730073_7856084438448405321_n.jpg?_nc_cat=109&_nc_sid=110474&_nc_ohc=MOTGcTHxUBsAX9Xod4M&_nc_ht=scontent.fkul15-1.fna&_nc_tp=7&oh=11c4efba3a0a8d92fd4a56d00c9633c1&oe=5F615654",
                   :width=>720}},
               :target=>
                {:id=>"153221466396740",
                 :url=>
                  "https://www.facebook.com/109726977412856/photos/a.153221496396737/153221466396740/?type=3"},
               :type=>"photo",
               :url=>
                "https://www.facebook.com/109726977412856/photos/a.153221496396737/153221466396740/?type=3"}]},
          :insights=>
           {:data=>
             [{:name=>"post_engaged_users",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_engaged_users/lifetime"},
              {:name=>"post_negative_feedback",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_negative_feedback/lifetime"},
              {:name=>"post_negative_feedback_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_negative_feedback_unique/lifetime"},
              {:name=>"post_clicks",
               :values=>[{:value=>1}],
               :id=>"109726977412856_153221506396736/insights/post_clicks/lifetime"},
              {:name=>"post_clicks_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_clicks_unique/lifetime"},
              {:name=>"post_engaged_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_engaged_fan/lifetime"},
              {:name=>"post_impressions",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions/lifetime"},
              {:name=>"post_impressions_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_unique/lifetime"},
              {:name=>"post_impressions_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_paid/lifetime"},
              {:name=>"post_impressions_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_paid_unique/lifetime"},
              {:name=>"post_impressions_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_fan/lifetime"},
              {:name=>"post_impressions_fan_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_fan_unique/lifetime"},
              {:name=>"post_impressions_fan_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_fan_paid/lifetime"},
              {:name=>"post_impressions_fan_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_fan_paid_unique/lifetime"},
              {:name=>"post_impressions_organic",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_organic/lifetime"},
              {:name=>"post_impressions_organic_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_organic_unique/lifetime"},
              {:name=>"post_impressions_viral",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_viral/lifetime"},
              {:name=>"post_impressions_viral_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_viral_unique/lifetime"},
              {:name=>"post_impressions_nonviral",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_nonviral/lifetime"},
              {:name=>"post_impressions_nonviral_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153221506396736/insights/post_impressions_nonviral_unique/lifetime"}],
            :paging=>
             {:previous=>
               "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597042800&until=1597215600",
              :next=>
               "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597388400&until=1597561200"}},
          :id=>"109726977412856_153221506396736"},
         {:permalink_url=>
           "https://www.facebook.com/109726977412856/posts/153220469730173/",
          :message=>"Test testTTTT",
          :insights=>
           {:data=>
             [{:name=>"post_engaged_users",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_engaged_users/lifetime"},
              {:name=>"post_negative_feedback",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_negative_feedback/lifetime"},
              {:name=>"post_negative_feedback_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_negative_feedback_unique/lifetime"},
              {:name=>"post_clicks",
               :values=>[{:value=>0}],
               :id=>"109726977412856_153220469730173/insights/post_clicks/lifetime"},
              {:name=>"post_clicks_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_clicks_unique/lifetime"},
              {:name=>"post_engaged_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_engaged_fan/lifetime"},
              {:name=>"post_impressions",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions/lifetime"},
              {:name=>"post_impressions_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_unique/lifetime"},
              {:name=>"post_impressions_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_paid/lifetime"},
              {:name=>"post_impressions_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_paid_unique/lifetime"},
              {:name=>"post_impressions_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_fan/lifetime"},
              {:name=>"post_impressions_fan_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_fan_unique/lifetime"},
              {:name=>"post_impressions_fan_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_fan_paid/lifetime"},
              {:name=>"post_impressions_fan_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_fan_paid_unique/lifetime"},
              {:name=>"post_impressions_organic",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_organic/lifetime"},
              {:name=>"post_impressions_organic_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_organic_unique/lifetime"},
              {:name=>"post_impressions_viral",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_viral/lifetime"},
              {:name=>"post_impressions_viral_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_viral_unique/lifetime"},
              {:name=>"post_impressions_nonviral",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_nonviral/lifetime"},
              {:name=>"post_impressions_nonviral_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153220469730173/insights/post_impressions_nonviral_unique/lifetime"}],
            :paging=>
             {:previous=>
               "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597042800&until=1597215600",
              :next=>
               "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597388400&until=1597561200"}},
          :id=>"109726977412856_153220469730173"},
         {:permalink_url=>
           "https://www.facebook.com/109726977412856/posts/153207216398165/",
          :message=>"TESTTTT",
          :insights=>
           {:data=>
             [{:name=>"post_engaged_users",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_engaged_users/lifetime"},
              {:name=>"post_negative_feedback",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_negative_feedback/lifetime"},
              {:name=>"post_negative_feedback_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_negative_feedback_unique/lifetime"},
              {:name=>"post_clicks",
               :values=>[{:value=>0}],
               :id=>"109726977412856_153207216398165/insights/post_clicks/lifetime"},
              {:name=>"post_clicks_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_clicks_unique/lifetime"},
              {:name=>"post_engaged_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_engaged_fan/lifetime"},
              {:name=>"post_impressions",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions/lifetime"},
              {:name=>"post_impressions_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_unique/lifetime"},
              {:name=>"post_impressions_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_paid/lifetime"},
              {:name=>"post_impressions_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_paid_unique/lifetime"},
              {:name=>"post_impressions_fan",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_fan/lifetime"},
              {:name=>"post_impressions_fan_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_fan_unique/lifetime"},
              {:name=>"post_impressions_fan_paid",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_fan_paid/lifetime"},
              {:name=>"post_impressions_fan_paid_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_fan_paid_unique/lifetime"},
              {:name=>"post_impressions_organic",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_organic/lifetime"},
              {:name=>"post_impressions_organic_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_organic_unique/lifetime"},
              {:name=>"post_impressions_viral",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_viral/lifetime"},
              {:name=>"post_impressions_viral_unique",
               :values=>[{:value=>0}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_viral_unique/lifetime"},
              {:name=>"post_impressions_nonviral",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_nonviral/lifetime"},
              {:name=>"post_impressions_nonviral_unique",
               :values=>[{:value=>1}],
               :id=>
                "109726977412856_153207216398165/insights/post_impressions_nonviral_unique/lifetime"}],
            :paging=>
             {:previous=>
               "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597042800&until=1597215600",
              :next=>
               "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597388400&until=1597561200"}},
          :id=>"109726977412856_153207216398165"}],
       :paging=>
        {:cursors=>
          {:before=>
            "QVFIUjY3TXU0NXhOMjMzdGxOX1R3ZAlE1a1daeHJHNFdESk1PV0tnX2lIX1JDTDh5TEUzRUJUcGw4M1drTl9BM2VfRnMwLWFiTHpSY09JWU9XX0FDVnFhY1RNTWFIMDJ2NUxnaEZALZAy04bUxSUUQwTHlKc0JhUVRFMEgyV1B0OEFnWG5i",
           :after=>
            "QVFIUlJQckNfcklKUDlUbm9sZAXpGZAGZAsT09ERGFzd09LbWpwNHlWazNOVDFhRE9fZA19LU2dQRVViSjJWN2VZAcjh3RXBMRFFrTlZA3cU5qVWFLeHdvRlJKaTJybmg3UnlnUi1zZAzJNWXdjOWhScWJMT1lWa2t6UElHZAEI3bVNHOXQ2VV9j"}}}
    end
  end
end