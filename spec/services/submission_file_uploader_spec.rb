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
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(FileHasher).to have_received(:short_hash).with(OpenSSL::Digest::SHA1.new, file)
    end

    it 'uploads the file to S3 with the correct path and the same extension as the original file' do
      file_name = 'candidate_name.tar'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.tar"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'accepts type for uploaded file' do
      file_name = 'resume.pdf'
      expected_path = "submissions/#{submission.id}/resume-#{submission.id}-#{hash}.pdf"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'resume')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'uploads the file to S3 with the same extension as the original file' do
      file_name = 'candidate_name.jar'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.jar"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'uploads the file to S3 with the same extension as the original file if it ends with tar.gz' do
      file_name = 'candidate_name.tar.gz'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.tar.gz"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'uploads the file to S3 with the same extension as the original file if it ends with tar.bz2' do
      file_name = 'candidate_name.tar.bz2'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.tar.bz2"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'strips off all other dots in the filename and keeps the extension even when extension has a dot' do
      file_name = 'candidate.first.name.last.name.tar.gz'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.tar.gz"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

    it 'strips off all other dots in the filename and keeps the extension' do
      file_name = 'candidate.first.name.last.name.zip'
      expected_path = "submissions/#{submission.id}/codetest-#{submission.id}-#{hash}.zip"
      SubmissionFileUploader.upload(submission, encoded_file, file_name, 'codetest')

      expect(S3Uploader).to have_received(:upload).with(expected_path, file)
    end

  end
end
