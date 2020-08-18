class Analytics::ZoomService
  class << self
    def get_webinar_full_stats(reported_webinar_id = nil)
      webinars = get_webinar_lists[:webinars]
      last_position = reported_webinar_id ? webinars.find_index{|wb| wb[:id] == reported_webinar_id.to_i} : -1

      webinar_stats = webinars[(last_position + 1)..].map do |web|
        stats = get_webinar_stats(web[:id])
        {
          topic: stats[:topic],
          webinar_uuid: web[:uuid],
          webinar_id: web[:id],
          start_time: date_convert(stats[:start_time]),
          duration: stats[:duration],
          participants: stats[:participants_count]
        }
      end

      past_webinars = webinar_stats.filter{|ws| !ws[:start_time].nil?}
      past_webinars.map do |pw|
        registrants = get_webinar_registrants(pw[:webinar_id])
        absentees = get_webinar_absentees(pw[:webinar_uuid])
        pw[:total_registrants] = registrants[:total_records]
        pw[:absentees] = absentees[:total_records] || 0
        pw
      end
    end

    # private
    def date_convert(datetime = nil)
      (DateTime.parse(datetime) + 8.hours).strftime('%d %B %Y - %H%M HRS') if datetime
    end

    def get_webinar_lists
      url = "https://api.zoom.us/v2/users/#{Rails.application.credentials.zoom[:user_id]}/webinars?page_size=300"
      response = call(url)
      parse_response(response)
    end

    def get_webinar_stats(webinar_id)
      url = "https://api.zoom.us/v2/report/webinars/#{webinar_id}"
      response = call(url)
      parse_response(response)
    end

    def get_webinar_registrants(webinar_id)
      url = "https://api.zoom.us/v2/webinars/#{webinar_id}/registrants"
      response = call(url)
      parse_response(response)
    end

    def get_webinar_absentees(webinar_uuid)
      url = "https://api.zoom.us/v2/past_webinars/#{webinar_uuid}/absentees"
      response = call(url)
      parse_response(response)
    end

    def call(url)
      Faraday.get(url) do |req|
        req.headers['Authorization'] = "Bearer #{encode_payload}"
      end
    end

    def parse_response(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def encode_payload
      payload = {
        iss: Rails.application.credentials.zoom[:api_key],
        exp: (Time.now + 10.minutes).to_i
      }

      JWT.encode(payload, Rails.application.credentials.zoom[:api_secret])
    end
  end
end