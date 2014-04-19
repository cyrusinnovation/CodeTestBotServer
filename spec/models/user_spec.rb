require 'spec_helper'

describe User do
  let(:auth_details) { {
      uid: '123456789',
      info: {
          name: 'Bob',
          email: 'bob@example.com'
      }
  } }
  let(:assessor_role) { Role.find_by_name('Assessor') }
  let(:recruiter_role) { Role.find_by_name('Recruiter') }
  let(:administrator_role) { Role.find_by_name('Administrator') }

  describe '#remove_role' do
    context 'when a user has more than one role' do
      let(:user) { User.create({uid: 'test', name: 'Alice', email: 'alice@example.com', roles: [assessor_role, recruiter_role]}) }

      context 'when user has the role to remove' do
        subject {
          user.remove_role(assessor_role)
          user
        }

        its(:roles) { should have_exactly(1).role }
        its(:roles) { should include(recruiter_role) }
      end

      context 'when user does not have the role to remove' do
        subject {
          user.remove_role(administrator_role)
          user
        }

        its(:roles) { should have_exactly(2).roles }
        its(:roles) { should include(assessor_role, recruiter_role) }
      end
    end

    context 'when a user has a single role' do
      let(:user) { User.create({uid: 'test', name: 'Alice', email: 'alice@example.com', roles: [assessor_role]}) }

      it 'raises forbidden error' do
        expect { user.remove_role(assessor_role) }.to raise_error HttpStatus::Forbidden, 'Cannot remove all roles from a User.'
      end
    end
  end

  describe '.find_or_create_by_auth_hash' do

    subject(:user) { User.find_or_create_from_auth_hash auth_details }

    context 'when user with UID exists' do
      before { User.create({uid: auth_details[:uid], name: 'Alice', email: 'alice@example.com'}) }

      it 'should find the existing user' do
        expect(user.uid).to eql(auth_details[:uid])
        expect(user.name).to eql('Alice')
        expect(user.email).to eql('alice@example.com')
        expect(User.count).to eql(1)
      end
    end

    context 'when user does not exist' do
      it 'should create user from auth hash' do
        expect(user.uid).to eql(auth_details[:uid])
        expect(user.name).to eql(auth_details[:info][:name])
        expect(user.email).to eql(auth_details[:info][:email])
        expect(user.editable).to be_true
        expect(User.count).to eql(1)
      end

      its(:roles) { should include(assessor_role) }
    end
  end
end
