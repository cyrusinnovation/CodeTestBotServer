class Submission < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :language
  has_many :assessments
  has_many :assessors, through: :assessments

  delegate :level, to: :candidate

  has_attached_file :zipfile,
                    :storage => :s3,
                    :s3_credentials => Proc.new { |attachment| attachment.instance.s3_credentials },
                    :s3_storage_class => :reduced_redundancy

  def s3_credentials
    {
        :bucket => Figaro.env.submissions_bucket,
        :access_key_id => Figaro.env.aws_access_key_id,
        :secret_access_key => Figaro.env.aws_secret_access_key
    }
  end

  def close
    update_attribute(:active, false)
  end

  def self.create_from_json(submission)
    file = Base64FileDecoder.decode_to_file submission.fetch(:zipfile)
    candidate = Candidate.find(submission.fetch(:candidate_id))

    language = nil
    if submission.include? :language_id
      language = Language.find(submission.fetch(:language_id))
    end

    create!(email_text: submission.fetch(:email_text), zipfile: file, candidate: candidate, language: language)
  end
end
