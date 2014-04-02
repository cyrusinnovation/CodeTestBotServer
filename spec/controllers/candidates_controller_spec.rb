require 'spec_helper'

describe CandidatesController do
  before(:each) do
    @level = Level.find_by_text('Junior')
  end

  it 'should create a candidate' do
    post :create, {candidate: {name: 'Bob', email: 'bob@example.com', level_id: @level.id}}

    expect(Candidate.count).to eql(1)
    expect(Candidate.last.name).to eql('Bob')
    expect(Candidate.last.email).to eql('bob@example.com')
    expect(Candidate.last.level.text).to eql(@level.text)
  end

  it 'should list candidates and include level in payload' do
    Candidate.create(name: 'Bob', email: 'bob@example.com', level_id: @level.id)

    get :index

    expect(response.body).to be_json_eql([{name:'Bob', email: 'bob@example.com', level_id: @level.id}].to_json).at_path('candidates')
    expect(response.body).to be_json_eql([{text: @level.text}].to_json).at_path('levels')
  end
end