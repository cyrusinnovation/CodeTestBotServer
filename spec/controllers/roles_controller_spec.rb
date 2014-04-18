require 'spec_helper'

describe RolesController do
  include UserHelper

  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'when session exists' do
      before { add_user_without_role_to_session }
      let(:expected) { [{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}].to_json }

      subject(:body) { response.body }

      it { should be_json_eql(expected).at_path('roles') }
    end
  end
end
