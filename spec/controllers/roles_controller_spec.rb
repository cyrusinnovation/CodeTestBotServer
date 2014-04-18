require 'spec_helper'

describe RolesController do
  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'when session exists' do
      before { add_user_to_session('Assessor') }
      let(:expected) { [{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}].to_json }

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('roles') }
    end
  end
end
