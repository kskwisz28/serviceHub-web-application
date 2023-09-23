module ServiceHub
  class LeadPassEmailClient
    attr_reader :access_token
    attr_reader :lead_pass

    def initialize(access_token, lead_pass)
      @access_token = access_token
      @lead_pass = lead_pass
    end

    def send_email
      MsGraphClient.new(access_token, email_payload).send_email
    end

    private

    def email_payload
      {
        message: {
          subject: subject,
          body: {
            'contentType' => 'HTML',
            'content' => rendered_email || ''
          },
          'toRecipients' => recipients.map { |email| { 'emailAddress' => {'address' => email} } },
        }
      }
    end

    def subject
      "GP2 ServiceHub Lead --  #{lead_pass.region}, #{lead_pass.country}, #{lead_pass.zip} -- #{lead_pass.reference_instrument} -- #{lead_pass.serial_number} -- #{categories.join(", ")}"
    end

    def categories
      [
        "training",
        "consulting_services",
        "qualifications",
        "instrument_service_plans",
      ].select do |category|
        lead_pass.public_send(category)
      end
    end

    def recipients
      if lead_pass.consulting_services
        if lead_pass.region == "NA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_CONSULTING_NA")
        elsif lead_pass.region == "EMEA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_CONSULTING_EMEA")
        end
      elsif lead_pass.training
        if lead_pass.region == "NA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_TRAINING_NA")
        elsif lead_pass.region == "EMEA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_TRAINING_EMEA")
        end
      else
        if lead_pass.region == "NA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_DEFAULT_NA")
        elsif lead_pass.region == "EMEA"
          ENV.fetch("LEAD_PASS_EMAIL_LIST_DEFAULT_EMEA")
        end
      end.split(",").map(&:strip)
    end

    def rendered_email
      @rendered_email ||= LeadPassEmailRenderer.new(lead_pass).render
    end
  end
end
