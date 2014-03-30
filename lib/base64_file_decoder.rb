class Base64FileDecoder
  def self.decode_to_file(base64_str)
    header, data = base64_str.split(',')
    file = Tempfile.new('codetestbot-submission')
    file.binmode
    file.write(Base64.decode64(data))
    file
  end
end