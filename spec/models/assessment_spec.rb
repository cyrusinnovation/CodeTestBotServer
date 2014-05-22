require 'spec_helper'

describe Assessment do
  it 'can be created as a link between a submission and assessor' do
    submission = Submission.create({email_text: 'test'})
    assessor = Assessor.create({name: 'Bob'})

    Assessment.create({submission: submission, assessor: assessor, score: 5, notes: 'Amazing!'})

    expect(Assessment.count).to eql(1)
    expect(Assessment.first.submission).to eql(submission)
    expect(Assessment.first.assessor).to eql(assessor)
    expect(Assessment.first.score).to eql(5)
    expect(Assessment.first.notes).to eql('Amazing!')
  end

  describe '.create_from_json' do
    let(:candidate) { Candidate.create({name: 'Test Candidate'})}
    let(:submission) { Submission.create({email_text: 'A submission', candidate: candidate}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}} }

    subject(:creation) { Assessment.create_from_json(assessment_data[:assessment]) }

    it 'should create an assessment' do
      expect { creation }.to change(Assessment, :count).from(0).to(1)
    end

    its(:submission) { should eql(submission) }
    its(:assessor) { should eql(assessor) }
    its(:score) { should eq(5) }
    its(:notes) { should eq('Fantastic!') }
  end
end
