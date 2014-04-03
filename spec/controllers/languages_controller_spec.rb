require 'spec_helper'

describe LanguagesController do

  describe :index do
    it 'should render all Languages as JSON' do
      expected = [{name: 'Java'}, {name: 'Ruby'}].to_json
      get :index
      expect(response.body).to be_json_eql(expected).at_path('languages')
    end
  end

end
