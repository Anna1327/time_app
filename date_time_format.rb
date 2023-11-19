# frozen_string_literal: true

class DateTimeFormat
  attr_reader :params, :params_available, :valid, :wrong_params

  VALID_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(params)
    @params = params.split(',')
    @available_params = VALID_FORMATS.keys
    @valid = []
    @wrong_params = []
  end

  def call
    @params.each do |param|
      @valid << find_valid_params(param)
      @wrong_params << find_wrong_params(param)
    end
    @wrong_params.compact!.to_s
  end

  def valid?
    @params == @valid
  end

  def find_valid_params(param)
    param if @available_params.include?(param)
  end

  def find_wrong_params(param)
    param unless @available_params.include?(param)
  end

  def prepare_datetime
    datetime_string = @params.map { |param| VALID_FORMATS[param] }.compact.join('-')
    Time.now.strftime(datetime_string)
  end
end