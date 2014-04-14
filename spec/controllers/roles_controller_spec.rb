require 'spec_helper'
require 'pry'
require 'controllers/user_helper'

describe RolesController do

  include UserHelper

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


end
