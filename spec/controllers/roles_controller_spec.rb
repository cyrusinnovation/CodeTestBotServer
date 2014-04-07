require 'spec_helper'
require 'pry'

describe RolesController do

  def add_normal_user_to_session
    token = '123456789'
    expiry = Time.now.utc + 20.minutes
    @user = User.create({ name: 'Bob', email: 'bob@example.com' })
    Session.create({token: token, token_expiry: expiry, user: @user})
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  def add_admin_to_session
    token = '123456789'
    expiry = Time.now.utc + 20.minutes
    admin_role = Role.find_by_name('Administrator')
    @user = User.create({ name: 'Admin', email: 'admin@example.com', role_id: admin_role.id })
    Session.create({token: token, token_expiry: expiry, user: @user})
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  describe :index do

    before(:each) do
      add_normal_user_to_session
    end

    it 'should render all Roles as JSON' do
      expected = [{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('roles')
    end
  end

  describe :assign_role_to_user do

  	it 'should not allow unauthorised people to add roles' do
      add_normal_user_to_session
  		role = Role.find_by_name('Assessor')
      lambda {post :assign_role_to_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)

    end

    it 'should allow users with the administrator role to assign roles' do
      add_admin_to_session
      role = Role.find_by_name('Assessor')
      user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      expect(response).to be_success
      user2 = User.find_by_name('Kate')
      expect(user2.role.name).to eql(role.name)
    end

  end
end
