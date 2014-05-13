require 'spec_helper'

describe UsersController do
  let(:admin_role) { Role.find_by_name('Administrator') }
  let(:kate) { User.create({name: 'Kate', email: 'kate@example.com'}) }
  let(:expected_kate) { {email: kate.email, name: kate.name, editable: true, role_ids: []} }
  let(:expected_kate_with_role) { {email: kate.email, name: kate.name, editable: true, role_ids: [admin_role.id]} }

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

  describe '#show' do
    let(:params) {{ id: kate.id }}
    subject(:response) {get :show, params}
    context 'when an admin user looks at kate' do
      before { add_user_to_session('Administrator') }
      let(:expected) {{roles: [], user: expected_kate}.to_json}
      its(:body) {should be_json_eql(expected)}
    end

    context 'when a recruiter looks at kate' do
      before { add_user_to_session('Recruiter') }
      it {should be_forbidden}
    end
  end

  describe '#update' do
    subject(:response) {post :update, params}

    context 'when an admin user submits an update' do
      let(:params) {{ id: kate.id, user: expected_kate_with_role }}
      before { add_user_to_session('Administrator') }
      let(:expected) {{roles: [{name: 'Administrator'}], user: expected_kate_with_role}.to_json}
      its(:body) {should be_json_eql(expected)}
    end

    context 'when an assessor submits an update' do
      let(:params) {{ id: kate.id, user: expected_kate_with_role }}
      before { add_user_to_session('Assessor') }
      it {should be_forbidden}
    end

    context 'when an admin removes all roles from a user' do
      let(:params) {{ id: kate.id, user: expected_kate }}
      before { add_user_to_session('Administrator') }
      let(:expected) {{error: 'Cannot remove all roles from a User.'}.to_json}
      its(:body) {should be_json_eql(expected)}
    end

  end

end
