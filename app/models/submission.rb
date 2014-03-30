class Submission < ActiveRecord::Base
  has_attached_file :zipfile,
                    :storage => :s3,
                    :s3_credentials => Proc.new{|attachment| attachment.instance.s3_credentials },
                    :s3_storage_class => :reduced_redundancy

  def s3_credentials
    creds = {
        :bucket => Figaro.env.submissions_bucket,
        :access_key_id => Figaro.env.aws_access_key_id,
        :secret_access_key => Figaro.env.aws_secret_access_key
    }

    puts creds

    creds
  end
end
