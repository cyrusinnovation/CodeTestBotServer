require 'spec_helper'
require 'pry'

describe RolesController do

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

  describe :index do

    before(:each) do
      add_user_without_role_to_session
    end

    it 'should render all Roles as JSON' do
      expected = [{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('roles')
    end
  end

  describe :assign_role_to_user do

  	it 'should not allow users without a role to assign roles' do
      add_user_without_role_to_session
  		role = Role.find_by_name('Assessor')
      lambda {post :assign_role_to_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should not allow users with the Assessor role to assign roles' do
      add_user_to_session('Assessor')
      role = Role.find_by_name('Assessor')
      lambda {post :assign_role_to_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should not allow users with the Recruiter role to assign roles' do
      add_user_to_session('Recruiter')
      role = Role.find_by_name('Assessor')
      lambda {post :assign_role_to_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should allow users with the administrator role to assign roles' do
      add_user_to_session('Administrator')
      user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      role = Role.find_by_name('Assessor')
      expect(user2.roles.include? role).should be_false
      post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      expect(response).to be_success
      user2 = User.find_by_name('Kate')
      expect(user2.roles.include? role).should be_true
    end

  end
end
