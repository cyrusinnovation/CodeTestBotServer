class AssessmentCreator
  def self.create_assessment(assessment)
    Assessment.create_from_json(assessment)
  end

  def self.update_assessment(assessment, assessment_json)
    just_published = (!assessment.published && assessment_json[:published] == true)
    assessment = assessment.update_from_json(assessment_json)
    Notifications::Assessments.new_assessment(assessment) if just_published
    assessment
  end
end
