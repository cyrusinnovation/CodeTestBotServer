require_relative '../../app/services/file_hasher'

describe FileHasher do
  let(:expected_digest) { 'abc123' }
  let(:hash) { double() }
  let(:file) { double() }

  describe '.hash_file' do
    before {
      File.stub(:read).with(file).and_return('blah')
      hash.stub(:hexdigest).with('blah').and_return(expected_digest)
    }

    it 'hashes the file contents with the given hash' do
      result = FileHasher.hash_file(hash, file)

      expect(result).to eql(expected_digest)
    end
  end

  describe '.short_hash' do
    before { FileHasher.stub(:hash_file => expected_digest) }

    it 'returns the hashed contents, shortened to the given length' do
      result = FileHasher.short_hash(hash, file, 3)

      expect(result).to eql(expected_digest.slice(0, 3))
    end
  end
end

