require 'spec_helper'

describe S3Uploader do
  let(:file) { Tempfile.new('codetestbot-submission') }
  let(:expected) { "https://codetestbot-submissions-test.s3.amazonaws.com/#{File.basename(file)}.zip" }
  before {
    Figaro.env.stub(:submissions_bucket => 'codetestbot-submissions-test')
    Figaro.env.stub(:aws_access_key_id => 'access_key')
    Figaro.env.stub(:aws_secret_access_key => 'secret_key')
    FakeWeb.register_uri(:put, expected, :body => '')
  }

  it 'PUTs a file to S3 with the public-read acl' do
    S3Uploader.upload(file)

    expect(FakeWeb.last_request.method).to eq('PUT')
    expect(FakeWeb.last_request.uri).to eq(URI(expected))
    expect(FakeWeb.last_request.to_hash['x-amz-acl']).to eq(['public-read'])
  end

  it 'returns the URI to the file' do
    expect(S3Uploader.upload(file).to_s).to eq(expected)
  end
end

