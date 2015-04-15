require 'spec_helper'

describe SubmissionFileUploader do
  it 'uploads the codetest file to S3 with the correct path, hash, type and extension' do
    submission_id = 5
    encoded_file = double()
    file = double()
    hash = 'hash'
    Base64FileDecoder.stub(decode_to_file: file)
    FileHasher.stub(short_hash: hash)

    CodeTestBotServer::Application.config.file_uploader.stub(:upload)

    file_name = 'candidate_name.tar'
    expected_path = "submissions/#{submission_id}/codetest-#{submission_id}-#{hash}.tar"
    SubmissionFileUploader.upload(submission_id, encoded_file, file_name, 'codetest')

    expect(FileHasher).to have_received(:short_hash).with(OpenSSL::Digest::SHA1.new, file)
    expect(CodeTestBotServer::Application.config.file_uploader).to have_received(:upload).with(expected_path, file)
  end

  it 'uploads a non-codetest file with the correct path and filename without hashing the filename' do
    submission_id = 2
    encoded_file = double()
    file = double()
    file_name = 'candidate_resume.pdf'
    expected_path = "submissions/#{submission_id}/resume-#{submission_id}-#{file_name}"

    Base64FileDecoder.stub(decode_to_file: file)
    CodeTestBotServer::Application.config.file_uploader.stub(:upload)

    SubmissionFileUploader.upload(submission_id, encoded_file, file_name, 'resume')
    expect(CodeTestBotServer::Application.config.file_uploader).to have_received(:upload).with(expected_path, file)
  end

  it 'extension is parsed out correctly' do
    expect(SubmissionFileUploader.get_extension("candidate_name.jar")).to eq('jar')
    expect(SubmissionFileUploader.get_extension("candidate_name.tar.gz")).to eq('tar.gz')
    expect(SubmissionFileUploader.get_extension("candidate_name.tar.bz2")).to eq('tar.bz2')
    expect(SubmissionFileUploader.get_extension("candidate.first.name.last.name.tar.gz")).to eq('tar.gz')
    expect(SubmissionFileUploader.get_extension("candidate.first.name.last.name.zip")).to eq('zip')
  end
end
