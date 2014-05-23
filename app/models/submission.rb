class Submission < ActiveRecord::Base
  belongs_to :language
  belongs_to :level
  has_many :assessments
  has_many :assessors, through: :assessments

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
    level = Level.find(submission.fetch(:level_id))

    language = nil
    if submission.include? :language_id
      language = Language.find(submission.fetch(:language_id))
    end

    create!(
      candidate_name: submission.fetch(:candidate_name),
      candidate_email: submission.fetch(:candidate_email),
      email_text: submission.fetch(:email_text), 
      zipfile: file, 
      level: level, 
      language: language)
  end
end
