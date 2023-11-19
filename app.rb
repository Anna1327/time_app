# frozen_string_literal: true

require_relative 'date_time_format'
require 'rack'

class App
  def call(env)
    @env = env

    if request_invalid?
      response_failure
    else
      handle_request
    end
  end

  private

  def request_invalid?
    return true if @env['REQUEST_METHOD'] != 'GET' || time_invalid?
    false
  end

  def handle_request
    time_request
  end

  def response_failure
    return response(405, 'Method not allowed') unless @env['REQUEST_METHOD'] == 'GET'
    response(400, 'Expected params')
  end

  def time_request
    datetime = DateTimeFormat.new(time_now_format)

    datetime.call
    if datetime.valid?
      response(200, datetime.prepare_datetime)
    else
      response(400, "Unknown time format #{datetime.wrong_params}")
    end
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

  def time_invalid?
    time_now_format.nil? || time_now_format.empty?
  end
end