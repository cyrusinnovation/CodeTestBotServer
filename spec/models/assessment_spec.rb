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
    let(:submission) { Submission.create({email_text: 'A submission' }) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!', published: false}} }
    before { Submission.stub(:find => submission) }

    subject(:creation) { Assessment.create_from_json(assessment_data[:assessment]) }

    it 'should create an assessment' do
      expect { creation }.to change(Assessment, :count).from(0).to(1)
    end

    its(:submission) { should eql(submission) }
    its(:assessor) { should eql(assessor) }
    its(:score) { should eq(5) }
    its(:notes) { should eq('Fantastic!') }
    its(:published) { should be_false }

    context 'when user already has an assessment' do
      before { submission.stub(:has_assessment_by_assessor).with(assessor).and_return(true) }

      it 'should raise existing assessment error' do
        expect { creation }.to raise_error(Assessment::ExistingAssessmentError)
      end
    end

    describe 'the referenced submission' do
      subject { creation.submission }

      its(:assessments) { should have(1).assessment }
    end
  end

  describe '#age' do
    it 'returns the length of time since it was created' do
      time = Time.now.utc
      Timecop.freeze(time) do
        an_hour_ago = time - 1.hour
        assessment = Timecop.freeze(an_hour_ago) do
          Assessment.create!
        end

        expect(assessment.age).to eq 1.hour
      end
    end
  end
end
