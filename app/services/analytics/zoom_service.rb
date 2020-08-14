class Analytics::ZoomService
  class << self
    def get_webinar_full_stats
      webinars = get_webinar_lists[:webinars]&.filter{|web| DateTime.parse(web[:start_time]) < (DateTime.now - 1.day)}
      webinars.map do |web|
        stats = get_webinar_stats(web[:id])
        {
          stats: stats[:topic],
          start_time: date_convert(stats[:start_time]),
          end_time: date_convert(stats[:end_time]),
          total_minutes: stats[:total_minutes],
          participants: stats[:participants_count]
        }
      end
    end

    private
    def date_convert(datetime = nil)
      (DateTime.parse(datetime) + 8.hours).strftime('%d %B %Y - %H%M HRS') if datetime
    end

    def get_webinar_lists
      url = "https://api.zoom.us/v2/users/#{Rails.application.credentials.zoom[:user_id]}/webinars"
      response = call(url)
      parse_response(response)
    end

    def get_webinar_stats(webinar_id)
      url = "https://api.zoom.us/v2/report/webinars/#{webinar_id}"
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

# G analytics
# Zoom
# Youtube
# Facebook ads
