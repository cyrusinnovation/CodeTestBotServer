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
end
