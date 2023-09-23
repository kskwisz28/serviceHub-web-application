class ReverseLeadsPassController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :refresh_access_token, only: [:new]

  def create
    create_lead

    redirect_to leads_pass_path, notice: "Lead submitted!"
  end

  def models
    @models = File.read("app/assets/javascripts/models.json")

    render json: @models
  end

  def placeholder
    send_file("app/assets/images/instrument_icon_gray.svg")
  end

  def instrument_image
    if params[:model]
      send_file("/images/instruments/#{params[:model]}.jpg")
    end
  end

  private

  def create_lead
    lead_pass = LeadPass.new(email_message_params)
    lead_pass.update!(user: current_user)

    ServiceHub::LeadPassEmailClient.new(access_token, lead_pass).send_email
  end

  def email_message_params
    params.permit(
      :first_name,
      :last_name,
      :company,
      :position,
      :phone,
      :email,
      :region,
      :country,
      :zip,
      :instrument_nickname,
      :notes,
      :reference_instrument,
      :serial_number,
      :training,
      :qualifications,
      :consulting_services,
      :instrument_service_plans,
    )
  end
end
