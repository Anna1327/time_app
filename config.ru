# frozen_string_literal: true

require_relative 'middleware/logger'
require_relative 'app'

ROUTE = {
  '/time' => App.new
}.freeze

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run Rack::URLMap.new(ROUTE)