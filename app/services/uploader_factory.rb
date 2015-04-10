class UploaderFactory
  def self.get_uploader
    S3Uploader
  end
end
