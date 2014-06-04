require 'spec_helper'

describe SubmissionFileUploader do
  describe '.upload' do
    let(:submission) { double(:id => 5) }
    let(:encoded_file) { double() }
    let(:file) { double() }
    let(:hash) { 'hash' }
    let(:file_name) { 'candidate_name.zip' }

    before {
      Base64FileDecoder.stub(:decode_to_file => file)
      FileHasher.stub(:short_hash => hash)
      S3Uploader.stub(:upload)
    }

    it 'decodes the encoded file and hashes the contents' do
      SubmissionFileUploader.upload(submission, encoded_file, file_name)

      expect(FileHasher).to have_received(:short_hash).with(OpenSSL::Digest::SHA1.new, file)
    end

    it 'uploads the file to S3 with the correct path' do
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.zip"
      SubmissionFileUploader.upload(submission, encoded_file, file_name)

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'uploads the file to S3 with the same extension as the original file' do
      file_name = 'candidate_name.jar'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.jar"
      SubmissionFileUploader.upload(submission, encoded_file, file_name)

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'uploads the file to S3 with the same extension as the original file if it ends with tar.gz' do
      file_name = 'candidate_name.tar.gz'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.tar.gz"
      SubmissionFileUploader.upload(submission, encoded_file, file_name)

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

  end
end

