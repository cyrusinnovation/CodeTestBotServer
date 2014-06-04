
class SubmissionFileUploader

  def self.get_extension(file_name)
    file_name = file_name.downcase
    bits = file_name.split('.')
    extension = bits[-1]
    if extension == 'gz'
      return 'tar.gz'
    else
      return extension
    end
  end

  def self.upload(submission, encoded_file, file_name)
    file = Base64FileDecoder.decode_to_file(encoded_file)
    shorthash = FileHasher.short_hash(OpenSSL::Digest::SHA1.new, file)
    extension = self.get_extension(file_name)
    path = "submissions/#{submission.id}/codetest-#{submission.id}-#{shorthash}.#{extension}"
    S3Uploader.upload(path, file).to_s
  end
end

