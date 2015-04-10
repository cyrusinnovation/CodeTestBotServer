class Submission < ActiveRecord::Base
  belongs_to :language
  belongs_to :level
  has_many :assessments, :dependent => :delete_all
  has_many :assessors, through: :assessments

  def self.all_active
    where(active: true)
  end

  def self.all_with_average_score
    fields = ['id', 'candidate_name', 'candidate_email', 'email_text', 'zipfile', 'active', 'language_id', 'level_id', 'created_at', 'updated_at', 'source']
    submission_fields = fields.map { |f| 'submissions.' + f }.join(',')
    avg = ', round(avg(assessments.score) * 2) / 2 as average_score'
    select(submission_fields + avg).joins('LEFT JOIN assessments ON (assessments.submission_id = submissions.id AND assessments.published = TRUE)').group(submission_fields).order(updated_at: :desc)
  end

  def has_assessment_by_assessor(assessor)
    assessments.any? {|a| a.assessor == assessor}
  end

  def close
    update_attribute(:active, false)
  end

  def attach_zipfile(file_url)
    update_attribute(:zipfile, file_url)
  end

  def attach_resumefile(file_url)
    update_attribute(:resumefile, file_url)
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
