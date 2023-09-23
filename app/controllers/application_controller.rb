class ApplicationController < ActionController::Base
  EMAIL_FROM_HEADER = 'HTTP_X_MS_CLIENT_PRINCIPAL_NAME'.freeze
  ACCESS_TOKEN_FROM_HEADER = 'HTTP_X_MS_TOKEN_AAD_ACCESS_TOKEN'.freeze

  include SiteAlertConcern

  helper_method :current_user, :current_email_message, :logout_link

  def current_user
    @current_user ||= User.find_or_create_by!(email: current_email)
  end

  def current_email_message
    @current_email_message ||= EmailMessage.find_or_create_by!(user: current_user, status: "open")
  end

  def current_email
    Rails.configuration.custom_config['email'] || request.headers.fetch(EMAIL_FROM_HEADER)
  end

  def access_token
    Rails.configuration.custom_config['access_token'] || request.headers.fetch(ACCESS_TOKEN_FROM_HEADER)
  end

  def logout_link
    Rails.configuration.custom_config['logout_link']
  end

  # Get EasyAuth to update the access token before rendering a page
  def refresh_access_token
    refresh_access_token_endpoint = Rails.configuration.custom_config['refresh_token_endpoint']
    Faraday.get(refresh_access_token_endpoint)
  end

  def application_context
    @application_context ||=
      Struct.new(:user, :country, :audience).new(
        current_user,
        current_user.country_code,
        current_user.role,
      )
  end
end
