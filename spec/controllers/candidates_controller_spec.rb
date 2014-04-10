require 'spec_helper'

# FIXME: put me into a shared helper class!
def add_user_without_role_to_session
  token = '123456789'
  expiry = Time.now.utc + 20.minutes
  @user = User.create({ name: 'Bob', email: 'bob@example.com' })
  Session.create({token: token, token_expiry: expiry, user: @user})
  @request.headers['Authorization'] = "Bearer #{token}"
end

def add_user_to_session(role_name)
  token = '123456789'
  expiry = Time.now.utc + 20.minutes
  @role = Role.find_by_name(role_name)
  @user = User.create({ name: 'Bob', email: 'bob@example.com'})
  @user.roles.push(@role)
  Session.create({token: token, token_expiry: expiry, user: @user})
  @request.headers['Authorization'] = "Bearer #{token}"
end

describe CandidatesController do
  before(:each) do
    @level = Level.find_by_text('Junior')
  end

  it 'should not allow user without role to create a candidate' do
    add_user_without_role_to_session
    lambda {post :create, {candidate: {name: 'Bob', email: 'bob@example.com', level_id: @level.id}}}.should raise_exception(CanCan::AccessDenied)
    expect(Candidate.count).to eql(0)
  end

  it 'should not allow user with Assessor role to create a candidate' do
    add_user_to_session('Assessor')
    lambda {post :create, {candidate: {name: 'Bob', email: 'bob@example.com', level_id: @level.id}}}.should raise_exception(CanCan::AccessDenied)
    expect(Candidate.count).to eql(0)
  end

  it 'should allow user with Recruiter role to create a candidate' do
    add_user_to_session('Recruiter')
    post :create, {candidate: {name: 'Bob', email: 'bob@example.com', level_id: @level.id}}

    expect(Candidate.count).to eql(1)
    expect(Candidate.last.name).to eql('Bob')
    expect(Candidate.last.email).to eql('bob@example.com')
    expect(Candidate.last.level.text).to eql(@level.text)
  end

  it 'should allow user with Administrator role to create a candidate' do
    add_user_to_session('Administrator')
    post :create, {candidate: {name: 'Bob', email: 'bob@example.com', level_id: @level.id}}

    expect(Candidate.count).to eql(1)
    expect(Candidate.last.name).to eql('Bob')
    expect(Candidate.last.email).to eql('bob@example.com')
    expect(Candidate.last.level.text).to eql(@level.text)
  end

  it 'should allow user with Recruiter role to view list of candidates and include level in payload' do
    add_user_to_session('Recruiter')
    Candidate.create(name: 'Bob', email: 'bob@example.com', level_id: @level.id)

    get :index

    expect(response.body).to be_json_eql([{name:'Bob', email: 'bob@example.com', level_id: @level.id}].to_json).at_path('candidates')
    expect(response.body).to be_json_eql([{text: @level.text}].to_json).at_path('levels')
  end

  it 'should allow user with Administrator role to view list of candidates and include level in payload' do
    add_user_to_session('Administrator')
    Candidate.create(name: 'Bob', email: 'bob@example.com', level_id: @level.id)

    get :index

    expect(response.body).to be_json_eql([{name:'Bob', email: 'bob@example.com', level_id: @level.id}].to_json).at_path('candidates')
    expect(response.body).to be_json_eql([{text: @level.text}].to_json).at_path('levels')
  end

  it 'should not allow user with Assessor role to view list of candidates' do
    add_user_to_session('Assessor')
    lambda { get :index }.should raise_exception(CanCan::AccessDenied)
  end
end