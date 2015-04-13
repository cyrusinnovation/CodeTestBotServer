require 'fileutils'

class LocalUploader
  def self.upload(target_path, file)
    file.rewind
    upload_file_path = "uploads/#{target_path}"
    path_to_write_to = "public/#{upload_file_path}"
    
    FileUtils.mkdir_p(File.dirname(path_to_write_to))
    File.open(path_to_write_to, 'w') do |file_to_write|
      file_to_write.write file.read
    end
    "http://localhost:3000/#{upload_file_path}"
  end
end

