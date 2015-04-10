require "spec_helper"

describe NullUploader do
  it "does nothing" do
    path = "/this/that/theother"
    file = "file"
    expect(NullUploader.upload(path, file)).to eq(path)
  end
end
