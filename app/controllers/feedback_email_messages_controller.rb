# frozen_string_literal: true

require 'faraday'

class FeedbackEmailMessagesController < ApplicationController

  def new
    refresh_access_token

    @feeback = FeedbackEmailMessage.new

    if params[:q]
      @current_instrument_model = params[:q].split("=").last # this fixes a bug where if someone searched for multiple instruments, the current instrument would be one long string. This grabs the last searched for instrument.
    end

    @selections = subject_line_selections
  end

  def create
    create_feedback_email_message
  end

  def show
  end

  private

  def create_feedback_email_message
    email_message = FeedbackEmailMessage.new

    email_message.subject_line = email_message_params[:subject]
    email_message.body = email_message_params[:email_body]
    email_message.sender_email = current_user.email
    referral_instrument = email_message_params[:referral_instrument]

    if referral_instrument
      referral_instrument_text = "Referral instrument: #{referral_instrument}\n"

      email_message.body = email_message.body.prepend(referral_instrument_text)
    end

    if email_message.valid?
      email_message.save!

      ServiceHub::FeedbackEmailClient.new(access_token, email_message).send_email

      redirect_to feedback_email_message_path(email_message)
    end
  end

  def subject_line_selections
    [
      "Question about SKU or pricing",
      "ServiceHub experience survey",
      "Submit a new feature idea",
      "Report a technical issue"
    ].freeze
  end

  def email_message_params
    params.permit(:subject, :email_body, :referral_instrument)
  end
end