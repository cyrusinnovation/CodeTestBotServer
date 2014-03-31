require 'spec_helper'

describe CandidateSerializer do
  it 'should serialize fields to JSON' do
    candidate = Candidate.new({id: 1, name: 'Bob', email:'bob@example.com'})
    serializer = CandidateSerializer.new(candidate)

    expected_json = {candidate: {id: 1, name: 'Bob', email: 'bob@example.com'}}

    expect(serializer.as_json).to eql(expected_json)
  end
end