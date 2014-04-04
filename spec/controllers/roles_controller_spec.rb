require 'spec_helper'
require 'pry'

describe RolesController do
  describe :index do
    it 'should render all Roles as JSON' do
      expected = [{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('roles')
    end
  end

  describe :assign_role_to_user do

  	it 'should assign role to user' do
  		user = User.create({ name: 'Bob', email: 'bob@example.com' })
  		role = Role.find_by_name('Assessor')
  		post :assign_role_to_user, {role_change: {user_id: user.id, role_id: role.id}}
      	expect(response).to be_success
      	user = User.find_by_name('Bob')
      	expect(user.role.name).to eql(role.name)

      	user2 = User.create({ name: 'Kate', email: 'kate@example.com' })
      	post :assign_role_to_user, {role_change: {user_id: user2.id, role_id: role.id}}
      	expect(response).to be_success
      	user2 = User.find_by_name('Kate')
      	expect(user2.role.name).to eql(role.name)
      	binding.pry
  	end

  end
end
