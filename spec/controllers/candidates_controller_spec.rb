require 'spec_helper'

describe CandidatesController do
  let(:level) { Level.find_by_text('Junior') }
  let(:params) { {candidate: {name: 'Bob', email: 'bob@example.com', level_id: level.id}} }

  describe '#create' do

    subject(:response) { post :create, params }

    it_behaves_like 'a secured route'

    context 'when user does not have a role' do
      before { add_user_to_session('Assessor') }
      it { should be_forbidden }
      it { should_not have_created_candidate }
    end

    context 'when user has Assessor role' do
      before { add_user_to_session('Assessor') }
      it { should be_forbidden }
      it { should_not have_created_candidate }
    end

    %w(Recruiter Administrator).each do |role|
      context "when user has #{role} role" do
        before { add_user_to_session(role) }
        it 'should create candidate' do
          expect(response).to be_created
          expect(Candidate.count).to eql(1)
          expect(Candidate.last.name).to eql('Bob')
          expect(Candidate.last.email).to eql('bob@example.com')
          expect(Candidate.last.level.text).to eql(level.text)
        end
      end
    end

    RSpec::Matchers.define :have_created_candidate do |expected|
      match do
        Candidate.count > 0
      end
    end
  end

  describe '#index' do
    let!(:candidate) { Candidate.create(name: 'Bob', email: 'bob@example.com', level_id: level.id) }
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'when user has Assessor role' do
      before { add_user_to_session('Assessor') }
      it { should be_forbidden }
    end

    %w(Recruiter Administrator).each do |role|
      context "when user has #{role} role" do
        before { add_user_to_session(role) }
        subject(:body) { response.body }
        it { should be_json_eql([{name: 'Bob', email: 'bob@example.com', level_id: level.id}].to_json).at_path('candidates') }
        it { should be_json_eql([{text: level.text}].to_json).at_path('levels') }
      end
    end
  end
end
