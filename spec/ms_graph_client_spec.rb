require 'rails_helper'

RSpec.describe ServiceHub::MsGraphClient do
  let(:access_token) {'access-token'}
  let(:payload) {{'email' => 'payload'}}
  let(:request_double) {double('http-request')}
  let(:response_double) {double('http-response')}
  let(:request_header) {{}}
  let(:request_options) {{}}

  it 'sends an email' do
    expect(Faraday).to receive(:post)
      .with(Rails.configuration.custom_config['ms_graph_send_email_endpoint'])
      .and_yield(request_double)
      .and_return(response_double)
    req_header = request_header
    req_options = request_options
    allow(request_double).to receive(:headers).and_return(req_header)
    allow(request_double).to receive(:options).and_return(req_options)
    expect(request_double).to receive(:body=).with(payload.to_json)
    expect(response_double).to receive(:status).and_return(200)
    expect(response_double).to receive(:success?).and_return(true)

    expect(described_class.new(access_token, payload).send_email).to eq(true)

    expect(req_header['Content-Type']).to eq('application/json')
    expect(req_header['Authorization']).to eq("Bearer #{access_token}")
    expect(req_options['timeout']).to eq(5)
  end

  it 'raises an exception on server error' do
    setup_err_response_expectation(500, 'Internal Server Error')

    expect {described_class.new(access_token, payload).send_email}
      .to raise_error(described_class::ServerError)
  end

  it 'raises an exception on authorization error' do
    setup_err_response_expectation(401, 'Authorization error')

    expect {described_class.new(access_token, payload).send_email}
      .to raise_error(described_class::AuthorizationError)
  end

  it 'is not successful on other non-200s' do
    setup_err_response_expectation(400, 'Not found')

    expect(described_class.new(access_token, payload).send_email).to eq(false)
  end

  def setup_err_response_expectation(status, response_body)
    allow(Faraday).to receive(:post)
      .and_yield(request_double.as_null_object)
      .and_return(response_double)
    allow(response_double).to receive(:success?).and_return(false)
    allow(response_double).to receive(:status).and_return(status)
    allow(response_double).to receive(:body).and_return("{\"error\": \"#{response_body}\"}")
  end
end
