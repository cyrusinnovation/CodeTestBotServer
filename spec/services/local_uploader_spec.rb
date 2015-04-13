require 'spec_helper'

describe LocalUploader do
  let(:file) { Tempfile.new('codetestbot-submission') }
  let(:path) { 'submissions/test.zip' }
  
  it 'copy the file to the path specifed on the local server' do
    expected_content = 'test text'
    file.write(expected_content)

    local_uploader_upload = LocalUploader.upload(path, file)
    expect(local_uploader_upload).to eq("http://localhost:3000/uploads/#{path}")
    
    actual_file = File.open("public/uploads/#{path}")
    expect(actual_file.read).to eq expected_content
    
    File.delete(actual_file.path)
  end
end
