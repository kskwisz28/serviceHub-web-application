module ServiceHub
  class EmailClient
    DEFAULT_SUBJECT = 'Your Thermo Fisher Documents'.freeze

    include LiteratureHelper

    def initialize(access_token, email_message)
      @access_token = access_token
      @email_message = email_message
    end
     
    def send_email
      if email_message.status == 'complete'
        MsGraphClient.new(access_token, email_payload).send_email
      end
    end

    private

    attr_reader :access_token, :email_message

    def email_payload
      {
        message: {
          subject: DEFAULT_SUBJECT,
          body: {
            'contentType' => 'HTML',
            'content' => rendered_email || ''
          },
          'toRecipients' => [{
            'emailAddress' => {'address' => email_message.customer_email}
          }]
        }
      }
    end

    def rendered_email
      @rendered_email ||= EmailRenderer.new(email_message.email_body, transform(literatures)).render
    end

    def transform(literatures)
      literatures.reduce([]) do |acc, lit|
        acc << {image: thumbnail(lit.asset_url), link: lit.asset_url, public_title: lit.public_title}
        acc
      end
    end

    def literatures
      Literature.where(asset_url: email_message.literature_asset_urls)
    end
  end
end
