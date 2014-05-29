class S3Uploader
  def self.upload(path, file)
    s3 = AWS::S3.setup(Figaro.env.aws_access_key_id, Figaro.env.aws_secret_access_key)
    bucket = s3.bucket(Figaro.env.submissions_bucket)
    object = bucket.put_object_stream(path, file) do |object|
      object.acl = 'public-read'
    end

    bucket.bucket_uri(object)
  end
end

