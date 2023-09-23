module ServiceHub
  class FeedbackEmailRenderer
    DEFAULT_EMAIL_ERB_PATH = 'app/views/emails/default_feedback_email.html.erb'.freeze

    include ActionView::Helpers::AssetTagHelper

    def initialize(email_content)
      @message_fragments = fragments(email_content)
      @template = File.read(DEFAULT_EMAIL_ERB_PATH)
    end

    def render
      ERB.new(template).result(binding)
    end

    private

    attr_reader :email_content, :template

    def fragments(email_content)
      email_content.split("\n").insert(-2, "")
    end
  end
end