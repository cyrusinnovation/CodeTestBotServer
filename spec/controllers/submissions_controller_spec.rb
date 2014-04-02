require 'spec_helper'

describe SubmissionsController do
  before do
    FakeWeb.allow_net_connect = false

    @fake_env = double(:fake_env)
    allow(@fake_env).to receive(:submissions_bucket).and_return('codetestbot-submissions-test')
    allow(@fake_env).to receive(:aws_access_key_id).and_return('fake_key')
    allow(@fake_env).to receive(:aws_secret_access_key).and_return('fake_secret')
    allow(Figaro).to receive(:env).and_return(@fake_env)
  end

  after do
    FakeWeb.allow_net_connect = true
  end

  describe :index do
    before(:each) do

    end

    it 'returns an empty list when there are no submissions' do
      get :index
      expect(response.body).to have_json_size(0).at_path('submissions')
    end

    it 'returns all submissions as JSON with language/candidate in payload' do
      candidate = Candidate.create({name: 'Bob'})
      language = Language.find_by_name('Java')
      Submission.create({email_text: 'test', language: language, candidate: candidate})
      expected = [{email_text: 'test', zipfile: '/zipfiles/original/missing.png', language_id: language.id, candidate_id: candidate.id}].to_json

      get :index
      expect(response.body).to be_json_eql(expected).at_path('submissions')
      expect(response.body).to have_json_type(Integer).at_path('submissions/0/id')
      expect(response.body).to be_json_eql([{name: language.name}].to_json).at_path('languages')
      expect(response.body).to be_json_eql([{name: candidate.name, email: nil, level_id: nil}].to_json).at_path('candidates')
    end

  end

  describe :create do
    before do
      @file = Tempfile.new('codetestbot-submission')
      allow(Base64FileDecoder).to receive(:decode_to_file).and_return(@file)
      FakeWeb.register_uri(:put, "https://codetestbot-submissions-test.s3.amazonaws.com/tmp/test/uploads/#{File.basename(@file)}", :body => '')
      @language = Language.find_by_name('Java')
      @candidate = Candidate.create({name: 'Bob'})
    end

    it 'saves the email text' do
      email_text = 'a new code test.'
      post :create, {submission: {email_text: email_text, zipfile: 'header,====', candidate_id: @candidate.id}}
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.email_text).to eq email_text
    end

    it 'can upload a zipfile' do
      post :create, {submission: {email_text: '', zipfile: 'header,====', candidate_id: @candidate.id}}
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.zipfile.url).to include File.basename(@file)
    end

    it 'can set the level for a submission' do
      post :create, {submission: {email_text: '', zipfile: 'header,====', candidate_id: @candidate.id, language_id: @language.id}}
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.language.name).to eql(@language.name)
    end
  end
end
