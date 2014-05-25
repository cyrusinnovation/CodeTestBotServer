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

  describe '.find_or_create_by_auth_hash' do

    subject(:user) { User.find_or_create_from_auth_hash auth_details }

    context 'when user with UID exists' do
      before { User.create({uid: auth_details[:uid], name: 'Alice', email: 'alice@example.com'}) }

      it 'should find the existing user' do
        expect(User.count).to eql(1)
      end

      its(:uid) { should eql(auth_details[:uid]) }
      its(:name) { should eq 'Bob' }
      its(:email) { should eq 'alice@example.com' }
    end

    context 'when user does not exist' do
      it 'should create user from auth hash' do
        expect(user.uid).to eql(auth_details[:uid])
        expect(user.name).to eql(auth_details[:info][:name])
        expect(user.email).to eql(auth_details[:info][:email])
        expect(user.editable).to be_true
        expect(User.count).to eql(1)
      end

      its(:role) { should eql(assessor_role) }
    end
  end
end
