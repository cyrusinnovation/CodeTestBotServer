class AssessmentsController < ApplicationController
  def create
    assessment = params[:assessment]
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
