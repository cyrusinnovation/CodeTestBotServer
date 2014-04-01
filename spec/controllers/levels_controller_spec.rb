require 'spec_helper'

describe LevelsController do

  it 'should render all Levels as JSON' do
    expected = ['Junior', 'Mid', 'Senior', 'Tech Lead'].collect_concat {|l| {text: l}}.to_json
    get :index
    expect(response.body).to be_json_eql(expected).at_path('levels')
  end
end