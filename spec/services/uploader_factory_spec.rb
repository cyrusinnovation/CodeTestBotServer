require "spec_helper"

describe UploaderFactory do

  before do
    @oldConfig = CodeTestBotServer::Application.config.file_uploader
  end

  after do
    CodeTestBotServer::Application.config.file_uploader = @oldConfig
  end

  it "returns the configured uploader" do
    class TestUploader; end
    CodeTestBotServer::Application.config.file_uploader = TestUploader

    expect(UploaderFactory.get_uploader).to eq TestUploader
  end
end
