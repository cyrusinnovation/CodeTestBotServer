
class FileHasher
  def self.hash_file(hash, file)
    hash.hexdigest(File.read(file))
  end

  def self.short_hash(hash, file, length = 8)
    hash_file(hash, file).slice(0, length)
  end
end

