require 'spec_helper'
require 'controllers/user_helper'

describe UsersController do

  include UserHelper

  describe :index do

    before(:each) do
      @admin_role = Role.find_by_name('Administrator')
      @assessor_role = Role.find_by_name('Assessor')
    end

    it 'should show all users' do
      add_user_to_session('Administrator')
      User.create({ name: 'Kate', email: 'kate@example.com' })
      expected = [{ name: 'Bob', email: 'bob@example.com', roles: [{name: 'Administrator'}] },
                  {email: 'kate@example.com', name: 'Kate', roles: []}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('users')
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
      expect(user2.roles.include? role).to be_false
      post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      expect(response).to be_success
      user2 = User.find_by_name('Kate')
      expect(user2.roles.include? role).to be_true
    end

    it 'should only assign a role once' do
      add_user_to_session('Administrator')
      user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      role = Role.find_by_name('Assessor')
      expect(user2.roles.include? role).to be_false
      post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      user2 = User.find_by_name('Kate')
      expect(user2.roles.size).to eql(1)
    end

    it 'should be able to assign multiple roles' do
      add_user_to_session('Administrator')
      user3 = User.create({ name: 'Kate', email: 'kate@example.com' })
      assessor_role = Role.find_by_name('Assessor')
      admin_role = Role.find_by_name('Administrator')
      post :assign_role_to_user, {role_change: {user_id: user3.id, role_id: assessor_role.id}}
      post :assign_role_to_user, {role_change: {user_id: user3.id, role_id: admin_role.id}}
      user3 = User.find_by_name('Kate')
      expect(user3.roles.size).to eql(2)
      expect(user3.roles.include? assessor_role).to be_true
      expect(user3.roles.include? admin_role).to be_true
    end

  end

  describe :remove_role_from_user do

    it 'should not allow users without a role to remove roles' do
      add_user_without_role_to_session
      role = Role.find_by_name('Assessor')
      lambda {post :remove_role_from_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should not allow users with the Assessor role to remove roles' do
      add_user_to_session('Assessor')
      role = Role.find_by_name('Assessor')
      lambda {post :remove_role_from_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should not allow users with the Recruiter role to remove roles' do
      add_user_to_session('Recruiter')
      role = Role.find_by_name('Recruiter')
      lambda {post :remove_role_from_user, {role_change: {user_id: @user.id, role_id: role.id}}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should allow users with the administrator role to remove roles' do
      add_user_to_session('Administrator')
      user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      role = Role.find_by_name('Assessor')
      user2.roles.push(role)
      expect(user2.roles.include? role).to be_true
      post :remove_role_from_user, {role_change: {user_id: user2.id, role_id: role.id}}
      expect(response).to be_success
      user2 = User.find_by_name('Kate')
      expect(user2.roles.include? role).to be_false
    end

    it 'should do nothing if asked to remove a role the user doesnt have' do
      add_user_to_session('Administrator')
      user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      role = Role.find_by_name('Assessor')
      user2.roles.push(role)
      expect(user2.roles.include? role).to be_true
      admin_role = Role.find_by_name('Administrator')
      post :remove_role_from_user, {role_change: {user_id: user2.id, role_id: admin_role.id}}
      expect(response).to be_success
      user2 = User.find_by_name('Kate')
      expect(user2.roles.include? role).to be_true
      expect(user2.roles.size).to eql(1)
    end

  end

  describe :filter_by_role do

    before(:each) do
      @admin_role = Role.find_by_name('Administrator')
      @assessor_role = Role.find_by_name('Assessor')
    end

    it 'should throw an error if not given a role to filter by' do
      add_user_to_session('Administrator')
      lambda { get :filter_by_role }.should raise_exception
    end

    it 'should not allow users without a role to assign roles' do
      add_user_without_role_to_session
      lambda {get :filter_by_role, {role_name: 'Assessor'}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should not allow users with the Assessor role to assign roles' do
      add_user_to_session('Assessor')
      lambda {get :filter_by_role, {role_name: 'Assessor'}}.should raise_exception(CanCan::AccessDenied)
    end

    it 'should only show users with the Assessor role' do
      add_user_to_session('Administrator')
      User.create({ name: 'Kate', email: 'kate@example.com' })
      expected = {users:[]}.to_json
      get :filter_by_role, {role_name: 'Assessor'}
      expect(response.body).to be_json_eql(expected)
    end

    it 'should render all Assessors as JSON' do
      add_user_to_session('Administrator')
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      bob = User.create({ name: 'Bob', email: 'bob@example.com' })
      bob.roles.push(@assessor_role)

      expected = {users: [{email: 'kate@example.com', name: 'Kate', roles: [{name: 'Assessor'}]},
                  {email: 'bob@example.com', name: 'Bob', roles: [{name: 'Assessor'}]}]}.to_json
      get :filter_by_role, {role_name: 'Assessor'}
      expect(response.body).to be_json_eql(expected)
    end

    it 'should render only Assessors as JSON' do
      add_user_to_session('Administrator')
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      bob = User.create({ name: 'Bob', email: 'bob@example.com' })
      bob.roles.push(@admin_role)

      expected = {users:[{email: 'kate@example.com', name: 'Kate', roles: [{name: 'Assessor'}]}]}.to_json
      get :filter_by_role, {role_name: 'Assessor'}
      expect(response.body).to be_json_eql(expected)
    end

    it 'should render Assessors as JSON even if they have other roles too' do
      add_user_to_session('Administrator')
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      kate.roles.push(@admin_role)

      expected = {users: [{email: 'kate@example.com', name: 'Kate', roles: [{name: 'Assessor'}, {name: 'Administrator'}]}]}.to_json
      get :filter_by_role, {role_name: 'Assessor'}
      expect(response.body).to be_json_eql(expected)
    end
  end


end
