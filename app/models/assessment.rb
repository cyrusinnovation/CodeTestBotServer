class Assessment < ActiveRecord::Base
  belongs_to :submission
  belongs_to :assessor

  def self.create_from_json(assessment)
    submission = Submission.find(assessment[:submission_id])
    assessor = Assessor.find(assessment[:assessor_id])

    Assessment.create({
      submission: submission,
      assessor: assessor,
      score: assessment[:score],
      notes: assessment[:notes]
    })
  end
end
