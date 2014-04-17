require 'spec_helper'
require 'controllers/user_helper'

describe LevelsController do
  include UserHelper

  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_without_role_to_session }
      let(:expected) { ['Junior', 'Mid', 'Senior', 'Tech Lead'].collect_concat { |l| {text: l} }.to_json }
      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('levels') }
    end
  end
end