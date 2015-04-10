require 'spec_helper'

describe SubmissionFileUploader do
  it 'uploads the file to S3 with the correct path, hash, type and extension' do
    submission_id = 5
    encoded_file = double()
    file = double()
    hash = 'hash'
    Base64FileDecoder.stub(decode_to_file: file)
    FileHasher.stub(short_hash: hash)
    S3Uploader.stub(:upload)

    file_name = 'candidate_name.tar'
    expected_path = "submissions/#{submission_id}/codetest-#{submission_id}-#{hash}.tar"
    SubmissionFileUploader.upload(submission_id, encoded_file, file_name, 'codetest')

    expect(FileHasher).to have_received(:short_hash).with(OpenSSL::Digest::SHA1.new, file)
    expect(S3Uploader).to have_received(:upload).with(expected_path, file)
  end

  it 'extension is parsed out correctly' do
    expect(SubmissionFileUploader.get_extension("candidate_name.jar")).to eq('jar')
    expect(SubmissionFileUploader.get_extension("candidate_name.tar.gz")).to eq('tar.gz')
    expect(SubmissionFileUploader.get_extension("candidate_name.tar.bz2")).to eq('tar.bz2')
    expect(SubmissionFileUploader.get_extension("candidate.first.name.last.name.tar.gz")).to eq('tar.gz')
    expect(SubmissionFileUploader.get_extension("candidate.first.name.last.name.zip")).to eq('zip')
  end
end
