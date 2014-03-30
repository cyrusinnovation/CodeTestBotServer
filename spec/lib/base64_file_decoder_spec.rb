require 'spec_helper'

describe Base64FileDecoder do
  it 'returns a file reference to the base64 decoded data' do
    tempfile = Tempfile.new('base64test')
    tempfile.write 'testing123'
    tempfile.rewind

    encoded = Base64.urlsafe_encode64(File.read(tempfile))
    decoded = Base64FileDecoder.decode_to_file "header,#{encoded}"
    decoded.rewind

    expect(File.read(decoded)).to eq('testing123')
  end
end