# frozen_string_literal: true

class DateTimeFormat
  attr_reader :params, :params_available

  DATE_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d'
  }.freeze

  TIME_FORMATS = {
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(params)
    @params = params.split(',')
    @available_params = DATE_FORMATS.keys + TIME_FORMATS.keys
  end

  def valid?
    @params.all? { |param| @available_params.include?(param) }
  end

  def wrong_params
    @params.map { |param| param unless @available_params.include?(param) }.compact!.to_s
  end

  def prepare_datetime
    date_string = @params.map { |param| DATE_FORMATS[param] }.compact.join('-')
    time_string = @params.map { |param| TIME_FORMATS[param] }.compact.join(':')
    Time.now.strftime("#{date_string} #{time_string}".strip)
  end
end