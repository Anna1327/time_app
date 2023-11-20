# frozen_string_literal: true

class DateTimeFormat
  attr_reader :params, :valid, :wrong_params

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
    @valid = []
    @wrong_params = []
  end

  def call
    @params.each do |param|
      if VALID_FORMATS[param]
        @valid << VALID_FORMATS[param]
      else
        @wrong_params << param
      end
    end
  end

  def valid?
    @wrong_params.empty?
  end

  def prepare_datetime
    Time.now.strftime(@valid.join('-'))
  end
end