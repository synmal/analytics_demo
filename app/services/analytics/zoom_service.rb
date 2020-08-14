class Analytics::ZoomService
  class << self
    def get_webinar_lists
      url = "https://api.zoom.us/v2/users/#{Rails.application.credentials.zoom[:user_id]}/webinars"
      response = call(url)
      parse_response(response)
    end

    def get_webinar_stats
      url = "https://api.zoom.us/v2/report/webinars/#{params[:webinar_id]}"
      response = call(url)
      parse_response(response)
    end

    private
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
