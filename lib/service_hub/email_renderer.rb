module ServiceHub
  class EmailRenderer
    DEFAULT_EMAIL_ERB_PATH = 'app/views/emails/default.html.erb'.freeze

    include ActionView::Helpers::AssetTagHelper

    def initialize(email_content, literatures)
      @message_fragments = fragments(email_content)
      @literatures = literatures
      @template = File.read(DEFAULT_EMAIL_ERB_PATH)
    end

    def render
      ERB.new(template).result(binding)
    end

    private

    attr_reader :email_content, :template

    def fragments(email_content)
      email_content.split("\n")
    end
  end
end
