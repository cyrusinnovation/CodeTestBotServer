require 'spec_helper'

describe URIValidation do

  class Dummy
    include URIValidation
  end

  before(:each) do
    @dummy = Dummy.new
  end

  it 'should return true if protocol is allowed' do
    uri = URI::parse('http://localhost')
    expect(@dummy.matches_protocol?(uri, :http)).to be_true
  end

  it 'should return false if protocol is not allowed' do
    uri = URI::parse('ftp://localhost')
    expect(@dummy.matches_protocol?(uri, :http, :https)).to be_false
  end
end