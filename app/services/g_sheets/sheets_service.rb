require 'google/apis/sheets_v4'

class GSheets::SheetsService

  class << self
    SCOPE = 'https://www.googleapis.com/auth/spreadsheets'
    SPREADSHEET_ID = '1G-LUggXthl9aXk6LwpqJY2A4ItjYFHd_lk3Pp5GDi2g'

    def push_data
      sheets_service = set_auth
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: generate_test)
      sheets_service.append_spreadsheet_value(SPREADSHEET_ID, 'Sendgrid!A1', value_range_object, value_input_option: 'RAW')
    end

    def set_auth
      _service = Google::Apis::SheetsV4::SheetsService.new
      _credentials = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('./service-account.json'), scope: SCOPE)
      _service.authorization = _credentials
      _service
    end

    # Temp
    def generate_test
      10.times.map { |i| ["email#{i}@example.com"] }
    end
  end
end