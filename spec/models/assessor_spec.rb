require 'spec_helper'

describe Assessor do
  it 'has a list of assessments and submissions through assessments' do
    assessor = Assessor.create({name: 'Bob'})
    submission = Submission.create({email_text: 'A submission'})
    assessment = Assessment.create({submission: submission, assessor: assessor, score: 5})

    expect(assessor.assessments.size).to eql(1)
    expect(assessor.submissions.size).to eql(1)
    expect(assessor.assessments.first).to eql(assessment)
    expect(assessor.submissions.first).to eql(submission)
  end
end