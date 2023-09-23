module ServiceHub
  class LeadPassEmailRenderer
    DEFAULT_EMAIL_ERB_PATH = 'app/views/emails/default_feedback_email.html.erb'.freeze

    include ActionView::Helpers::AssetTagHelper

    attr_reader :email_content, :template

    def initialize(lead_pass)
      @message_fragments = fragments(lead_pass)
      @template = File.read(DEFAULT_EMAIL_ERB_PATH)
    end

    def render
      ERB.new(template).result(binding)
    end

    private

    def fragments(lead_pass)
      [
        "First name: #{lead_pass.first_name}",
        "",
        "Last name: #{lead_pass.last_name}",
        "",
        "Company: #{lead_pass.company}",
        "",
        "Position: #{lead_pass.position}",
        "",
        "Phone: #{lead_pass.phone}",
        "",
        "Email: #{lead_pass.email}",
        "",
        "Region: #{lead_pass.region}",
        "",
        "Country: #{lead_pass.country}",
        "",
        "Zip/Postcode: #{lead_pass.zip}",
        "",
        "Instrument nickname: #{lead_pass.instrument_nickname}",
        "",
        "Serial number: #{lead_pass.serial_number}",
        "",
        "Notes: #{lead_pass.notes}",
        "",
        "Training: #{lead_pass.training?}",
        "",
        "Qualifications: #{lead_pass.qualifications?}",
        "",
        "Consulting services: #{lead_pass.consulting_services?}",
        "",
        "Instrument service plans: #{lead_pass.instrument_service_plans?}",
        "",
        "Submitted by: #{lead_pass.user.email}"
      ]
    end
  end
end
