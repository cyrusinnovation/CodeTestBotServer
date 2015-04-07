require 'spec_helper'

describe Assessment do
  it "requires a pro and a con" do
    submission = Submission.create({email_text: 'test'})
    assessor = Assessor.create({name: 'Bob'})

    assessment_no_pros_or_cons = Assessment.create({score: 5, notes: 'Amazing!'})
    assessment_no_cons = Assessment.create({score: 5, notes: 'Amazing!', pros: 'Good Code.'})
    assessment_no_pros = Assessment.create({score: 5, notes: 'Amazing!', cons: 'Bad tests.'})
    assessment = Assessment.create({score: 5, notes: 'Amazing!', cons: 'Bad tests.', pros: 'Good Code.'})
    expect(assessment_no_pros_or_cons.valid?).to be false
    expect(assessment_no_cons.valid?).to be false
    expect(assessment_no_pros.valid?).to be false
    expect(assessment.valid?).to be true
  end

  it 'can be created as a link between a submission and assessor' do
    submission = Submission.create({email_text: 'test'})
    assessor = Assessor.create({name: 'Bob'})

    expected_pros = 'Good Code!'
    expected_cons = 'No Tests.'
    Assessment.create({submission: submission, assessor: assessor, score: 5, notes: 'Amazing!', pros: expected_pros, cons: expected_cons})

    expect(Assessment.count).to eql(1)
    assessment = Assessment.first
    expect(assessment.submission).to eql(submission)
    expect(assessment.assessor).to eql(assessor)
    expect(assessment.score).to eql(5)
    expect(assessment.notes).to eql('Amazing!')
    expect(assessment.pros).to eql(expected_pros)
    expect(assessment.cons).to eql(expected_cons)
  end

  describe '.create_from_json' do
    let(:submission) { Submission.create({email_text: 'A submission'}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!', published: false, pros: 'Good Code!', cons: 'No Tests.'}} }
    before { Submission.stub(:find => submission) }

    subject(:creation) { Assessment.create_from_json(assessment_data[:assessment]) }

    it 'should create an assessment' do
      expect { creation }.to change(Assessment, :count).from(0).to(1)
    end

    its(:submission) { should eql(submission) }
    its(:assessor) { should eql(assessor) }
    its(:score) { should eq(5) }
    its(:notes) { should eq('Fantastic!') }
    its(:pros) { should eq('Good Code!') }
    its(:cons) { should eq('No Tests.') }
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

  describe '#update_from_json' do
    let(:submission) { Submission.create({email_text: 'A submission'}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment) { Assessment.create!({submission: submission, assessor: assessor, score: 5, notes: 'Fantastic!', published: false, pros: 'Good Code!', cons: 'No Tests.'}) }
    let(:assessment_data) { {assessment: {id: assessment.id, submission_id: submission.id, assessor_id: assessor.id, score: 4, notes: 'Not as good as I thought.', pros: 'Ok Code.', cons: 'Some Tests.', published: true}} }
    before { Submission.stub(:find => submission) }

    subject(:update) { assessment.update_from_json(assessment_data[:assessment]) }

    its(:submission) { should eql(submission) }
    its(:assessor) { should eql(assessor) }
    its(:score) { should eq(4) }
    its(:notes) { should eq('Not as good as I thought.') }
    its(:pros) { should eq('Ok Code.') }
    its(:cons) { should eq('Some Tests.') }
    its(:published) { should be_true }
  end

  describe '#age' do
    it 'returns the length of time since it was created' do
      time = Time.now.utc
      Timecop.freeze(time) do
        an_hour_ago = time - 1.hour
        assessment = Timecop.freeze(an_hour_ago) do
          Assessment.create!(pros: 'Good Code!', cons: 'No Tests.')
        end

        expect(assessment.age).to eq 1.hour
      end
    end
  end
end
