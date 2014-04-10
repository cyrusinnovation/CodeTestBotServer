require 'spec_helper'

describe AssessorsController do

  before(:each) do
    @admin_role = Role.find_by_name('Administrator')
    @assessor_role = Role.find_by_name('Assessor')
  end

  describe :index do

    it 'should only show users with the Assessor role' do
      User.create({ name: 'Kate', email: 'kate@example.com' })
      expected = [].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('assessors')
    end

    it 'should render all Assessors as JSON' do
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      bob = User.create({ name: 'Bob', email: 'bob@example.com' })
      bob.roles.push(@assessor_role)

      expected = [{email: 'kate@example.com', name: 'Kate'}, {email: 'bob@example.com', name: 'Bob'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('assessors')
    end

    it 'should render only Assessors as JSON' do
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      bob = User.create({ name: 'Bob', email: 'bob@example.com' })
      bob.roles.push(@admin_role)

      expected = [{email: 'kate@example.com', name: 'Kate'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('assessors')
    end

    it 'should render Assessors as JSON even if they have other roles too' do
      kate = User.create({ name: 'Kate', email: 'kate@example.com' })
      kate.roles.push(@assessor_role)
      kate.roles.push(@admin_role)

      expected = [{email: 'kate@example.com', name: 'Kate'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('assessors')
    end

  end

end
