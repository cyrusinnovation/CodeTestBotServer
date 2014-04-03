require 'spec_helper'

describe LanguagesController do

  describe :show do
    it 'should render all Languages as JSON' do
      expected = [{name: 'Java'}, {name: 'Ruby'}].to_json
      get :show
      expect(response.body).to be_json_eql(expected).at_path('languages')
    end
  end

end
