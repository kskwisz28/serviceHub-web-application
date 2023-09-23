# frozen_string_literal: true
module GoogleAnalytics
  TRACKING_ID = ENV['GOOGLE_ANALYTICS_ID'] || '123'
  JS_URL = "https://www.googletagmanager.com/gtag/js?id=#{GoogleAnalytics::TRACKING_ID}"
end