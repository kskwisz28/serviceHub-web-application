# frozen_string_literal: true

require 'faraday'

class EmailMessagesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :update

  def show
    refresh_access_token
  end

  def update
    if email_message_params[:email_body] && email_message_params[:customer_email]
      update_for_completed_email_message
    elsif email_message_params[:literature_asset_url]
      add_or_remove_lit_from_email_message
    end
  end

  def thank_you
  end

  private

  def add_or_remove_lit_from_email_message
    email_message = current_email_message
    @literature_asset_url = email_message_params[:literature_asset_url]
    if @literature_asset_url
      if current_email_message.literature_asset_urls.include?(@literature_asset_url)
        email_message.literature_asset_urls.delete(@literature_asset_url)
        email_message.save!
      else
        email_message.literature_asset_urls << @literature_asset_url
        email_message.save!
      end
    end
  end

  def update_for_completed_email_message
    email_message = current_email_message

    email_message.email_body = email_message_params[:email_body]
    email_message.customer_email = email_message_params[:customer_email]
    email_message.status = 'complete'

    if email_message.valid?
      email_message.save!

      ServiceHub::EmailClient.new(access_token, email_message).send_email
      
      redirect_to email_message_thank_you_path
    end
  end

  def email_message_params
    params.require(:email_message).permit(:literature_asset_url, :email_body, :customer_email)
  end
end
