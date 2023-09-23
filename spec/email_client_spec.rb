require 'rails_helper'

RSpec.describe ServiceHub::EmailClient do
  let(:access_token) {'access-token'}
  let(:email_content) {"Hello\nWorld!"}
  let(:lit_id) {"abcdefg"}
  let(:lit_asset_url) {'https://example.com/hello-world.pdf'}
  let(:customer_email) {'customer@example.com'}
  let(:email_renderer_double) {double('email-renderer')}
  let(:ms_graph_client_double) {double('ms-graph-client')}
  let(:literature) {Literature.new(asset_url: lit_asset_url)}

  def new_email_message(status)
    email_message = EmailMessage.new(email_body: email_content,
                     literature_asset_urls: [lit_id],
                     customer_email: customer_email,
                     status: status)
  end

  it 'sends the default email via MS Graph' do
    email_message = new_email_message('complete')
    expect(Literature)
      .to receive(:find).with([lit_id])
      .and_return([literature])
    expect(ServiceHub::EmailRenderer)
      .to receive(:new).with(email_content, [{image: 'literature/hello-world-thumbnail.png', link: lit_asset_url}])
      .and_return(email_renderer_double)
    expect(email_renderer_double).to receive(:render).and_return('rendered')

    payload = {
      message: {
        subject: described_class::DEFAULT_SUBJECT,
        body: {
          'contentType' => 'HTML',
          'content' => 'rendered'
        },
        'toRecipients' => [{
          'emailAddress' => {
            'address' => customer_email
          }
        }]
      }
    }

    expect(ServiceHub::MsGraphClient)
      .to receive(:new).with(access_token, payload)
      .and_return(ms_graph_client_double)
    expect(ms_graph_client_double).to receive(:send_email)

    described_class.new(access_token, email_message).send_email
  end

  it 'does not send default email if email message is in complete status' do
    email_message = new_email_message('open')
    expect(Literature).
      not_to receive(:find)
    expect(ServiceHub::EmailRenderer)
      .not_to receive(:new)
    expect(ServiceHub::MsGraphClient)
      .not_to receive(:new)

    described_class.new(access_token, email_message).send_email
  end
end
