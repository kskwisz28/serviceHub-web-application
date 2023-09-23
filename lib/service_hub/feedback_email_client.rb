module ServiceHub
  class FeedbackEmailClient

    def initialize(access_token, email_message)
      @access_token = access_token
      @email_message = email_message
    end

    def send_email
      MsGraphClient.new(access_token, email_payload).send_email
    end

    private

    attr_reader :access_token, :email_message

    def email_payload
      subject = "Feedback Form: #{email_message.subject_line}, From: #{email_message.sender_email}"

      {
        message: {
          subject: subject,
          body: {
            'contentType' => 'HTML',
            'content' => rendered_email || ''
          },
          'toRecipients' => [{
            'emailAddress' => {'address' => 'servicehub@thermofisher.com'}
          }]
        }
      }
    end

    def rendered_email
      @rendered_email ||= FeedbackEmailRenderer.new(email_message.body).render
    end
  end
end