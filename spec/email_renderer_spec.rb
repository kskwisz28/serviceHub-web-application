require 'rails_helper'

RSpec.describe ServiceHub::EmailRenderer do
  it 'renders default email template' do
    email_content = "Hello\n\nWorld!"
    literatures = [
      image: '/hello-world.jpg',
      link: 'https://example.com/hello-world.pdf'
    ]
    result = described_class.new(email_content, literatures).render

    expect(result).to include('Hello<br />')
    expect(result).to include('World!<br />')
    expect(result).to include('/hello-world.jpg')
    expect(result).to include('https://example.com/hello-world.pdf')
  end
end
