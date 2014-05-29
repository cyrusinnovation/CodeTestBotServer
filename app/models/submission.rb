class Submission < ActiveRecord::Base
  belongs_to :language
  belongs_to :level
  has_many :assessments
  has_many :assessors, through: :assessments

  def has_assessment_by_assessor(assessor)
    assessments.any? {|a| a.assessor == assessor}
  end

  def close
    update_attribute(:active, false)
  end

  def attach_file(file_url)
    update_attribute(:zipfile, file_url)
  end

  def self.create_from_json(submission)
    level = Level.find(submission.fetch(:level_id))

    language = nil
    if submission.include? :language_id
      language = Language.find(submission.fetch(:language_id))
    end

    create!(
      candidate_name: submission.fetch(:candidate_name),
      candidate_email: submission.fetch(:candidate_email),
      email_text: submission.fetch(:email_text), 
      level: level, 
      language: language)
  end
end
