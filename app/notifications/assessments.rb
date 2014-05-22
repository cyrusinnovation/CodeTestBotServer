module Notifications
  class Assessments
    def self.new_assessment(assessment)
      AssessmentMailer.new_assessment(assessment).deliver
    end
  end
end

