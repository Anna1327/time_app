# frozen_string_literal: true

require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    @logger.info(log_string(env))
    @app.call(env)
  end

  def log_string(env)
    "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']} #{env['QUERY_STRING']}"
  end
end