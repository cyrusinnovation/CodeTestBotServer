require 'spec_helper'

describe AssessmentsController do
  describe :create do
    it 'creates an assessment from submission and assessor' do
      submission = Submission.create({email_text: 'A submission'})
      assessor = Assessor.create({name: 'Bob'})

      post :create, {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}}

      expect(response).to be_success

      expect(Assessment.count).to eql(1)
      expect(Assessment.first.submission).to eql(submission)
      expect(Assessment.first.assessor).to eql(assessor)
      expect(Assessment.first.score).to eql(5)
      expect(Assessment.first.notes).to eql('Fantastic!')
    end
  end
end
