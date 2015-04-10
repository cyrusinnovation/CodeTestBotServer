class UploaderFactory
  def self.get_uploader
    CodeTestBotServer::Application.config.file_uploader
  end
end
