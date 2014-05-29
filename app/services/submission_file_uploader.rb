
class SubmissionFileUploader
  def self.upload(submission, encoded_file)
    file = Base64FileDecoder.decode_to_file(encoded_file)
    shorthash = FileHasher.short_hash(OpenSSL::Digest::SHA1.new, file)
    path = "submissions/#{submission.id}/codetest-#{submission.id}-#{shorthash}.zip"
    S3Uploader.upload(path, file).to_s
  end
end

