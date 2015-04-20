class SubmissionFileUploader

  def self.get_extension(file_name)
    file_name = file_name.downcase
    bits = file_name.split('.')
    extension = bits[-1]
    bit_before_extension = bits[-2]
    if bit_before_extension == 'tar'
      return "#{bit_before_extension}.#{extension}"
    else
      return extension
    end
  end

  def self.upload(submission_id, encoded_file, file_name, type)
    if type == 'codetest'
      file = Base64FileDecoder.decode_to_file(encoded_file)
      shorthash = FileHasher.short_hash(OpenSSL::Digest::SHA1.new, file)
      extension = self.get_extension(file_name)
      path = "submissions/#{submission_id}/#{type}-#{submission_id}-#{shorthash}.#{extension}"
    else
      file = Base64FileDecoder.decode_to_file(encoded_file)
      path = "submissions/#{submission_id}/#{type}-#{submission_id}-#{URI.encode(file_name)}"
    end

    CodeTestBotServer::Application.config.file_uploader.upload(path, file).to_s
  end
end
