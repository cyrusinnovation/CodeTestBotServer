require 'spec_helper'

describe UsersController do
  let(:admin_role) { Role.find_by_name('Administrator') }
  let(:kate) { User.create({name: 'Kate', email: 'kate@example.com'}) }
  let(:expected_kate) { {email: kate.email, name: kate.name, editable: true, role_ids: []} }

  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'when users exist' do
      before { add_user_to_session('Administrator') }
      let(:expected) { [{name: 'Bob', email: 'bob@example.com', editable: true, role_ids: [admin_role.id]},
                        expected_kate].to_json }

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('users') }
    end
  end

end
