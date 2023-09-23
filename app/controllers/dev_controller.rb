class DevController < ApplicationController
  layout false
  skip_before_action :verify_authenticity_token, only: [:send_mail]

  include LiteratureHelper

  def show_default_email
    literatures = [
      Literature.first,
      Literature.last,
    ]
    @message_fragments = ["Hello Customer,", "", "Here are the documents you have requested.", "", "Cheers,", "Sales Person"]
    @literatures = [
      {image: thumbnail(literatures[0].asset_url), link: literatures[0].asset_url, public_title: literatures[0].public_title },
      {image: thumbnail(literatures[1].asset_url), link: literatures[1].asset_url, public_title: literatures[1].public_title },
      {image: thumbnail(literatures[0].asset_url), link: literatures[0].asset_url, public_title: literatures[0].public_title },
      {image: thumbnail(literatures[1].asset_url), link: literatures[1].asset_url, public_title: literatures[1].public_title },
      {image: thumbnail(literatures[0].asset_url), link: literatures[0].asset_url, public_title: literatures[0].public_title },
    ]
    puts @literatures
    render "emails/default"
  end

  def show_default_feedback_email
    @message_fragments = ["Referral instrument: KF96DW", "", "Hello! I have a brilliant new feature idea for ServiceHub!"]
    render "emails/default_feedback_email"
  end

  def show_default_leads_pass_email
    @message_fragments = ["First name: James", "", "Last name: Doe", "", "Organization: Innovation, Inc.", "", "Position: Scientist", "", "Phone: 555-555-5555", "", "Email: jim@innovation.org", "", "Notes: Nice guy", "", "Reference instrument: KF96DW", "", "Submitted by: Jane Doe"]
    render "emails/default_feedback_email"
  end

  def send_mail
    render json: {}, status: :ok
  end
end
