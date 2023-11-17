# frozen_string_literal: true

require_relative 'date_time_format'
require 'rack'

class App
  def call(env)
    @env = env
    request_failure || time_request
  end

  private

  def request_failure
    return response(405, 'Method not allowed') unless @env['REQUEST_METHOD'] == 'GET'

    response(400, 'Expected params') if time_now_format.nil?
  end

  def time_request
    datetime = DateTimeFormat.new(time_now_format)
    return response(400, "Unknown time format #{datetime.wrong_params}") unless datetime.valid?

    response(200, datetime.prepare_datetime)
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def response(status, body)
    [status, headers, ["#{body}\n"]]
  end

  def time_now_format
    Rack::Utils.parse_query(@env['QUERY_STRING'])['format']
  end
end