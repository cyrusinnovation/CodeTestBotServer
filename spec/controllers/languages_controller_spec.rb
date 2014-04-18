require 'spec_helper'

describe LanguagesController do
  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }
      let(:expected) { [{name: 'Java'}, {name: 'Ruby'}].to_json }

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('languages') }
    end
  end
end
