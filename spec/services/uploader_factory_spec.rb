require "spec_helper"

describe UploaderFactory do

  it "returns s3uploader" do
    expect(UploaderFactory.get_uploader).to eq(S3Uploader)
  end
end
