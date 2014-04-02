class Submission < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :language
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
end
