class Submission < ActiveRecord::Base
  belongs_to :language
  belongs_to :level
  has_many :assessments, :dependent => :delete_all
  has_many :assessors, through: :assessments

  def self.all_active
    where(active: true)
  end

  def self.all_with_average_score
    # fields = ['id', 'candidate_name', 'candidate_email', 'email_text', 'zipfile', 'active', 'language_id', 'level_id', 'created_at', 'updated_at', 'source']
    # submission_fields = fields.map { |f| 'submissions.' + f }.join(',')
    # avg = ', round(avg(assessments.score) * 2) / 2 as average_score'
    # select(submission_fields + avg).joins('LEFT JOIN assessments ON (assessments.submission_id = submissions.id)').group(submission_fields).order(updated_at: :desc)
    submissions_array = []
    Submission.all.each do |submission|
      submission_hash = submission.as_json
      submission_hash[:average_score] = submission.average_published_assessment_score
      submissions_array.push(submission_hash)
      puts submission_hash
    end
    submissions_array
  end

  def average_published_assessment_score 
    score_sum = 0
    total_scores = 0
    assessments.each do  |assessment|
      if assessment.published 
        score_sum += assessment.score
        total_scores += 1
      end
    end
    if total_scores != 0
      score_sum / total_scores
    end
  end

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
      language: language,
      source: submission.fetch(:source))
  end
end
