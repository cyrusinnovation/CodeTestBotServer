require 'spec_helper'

describe CandidatesController do

  it 'should create a candidate' do
    post :create, {candidate: {name: 'Bob', email: 'bob@example.com'}}

    expect(Candidate.count).to eql(1)
    expect(Candidate.last.name).to eql('Bob')
    expect(Candidate.last.email).to eql('bob@example.com')
  end

  it 'should list candidates' do
    Candidate.create(name: 'Bob', email: 'bob@example.com')

    get :index

    expect(response.body).to be_json_eql([{name:'Bob', email: 'bob@example.com'}].to_json).at_path('candidates')
  end
end