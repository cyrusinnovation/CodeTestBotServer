require 'spec_helper'

describe User do

  describe '.find_or_create_by_auth_hash' do
    let(:auth_details) { {
        uid: '123456789',
        info: {
            name: 'Bob',
            email: 'bob@example.com'
        }
    } }

    subject(:user) { User.find_or_create_from_auth_hash auth_details }

    context 'when user with UID exists' do
      before { User.create({uid: auth_details[:uid], name: 'Alice', email: 'alice@example.com' }) }

      it 'should find the existing user' do
        expect(user.uid).to eql(auth_details[:uid])
        expect(user.name).to eql('Alice')
        expect(user.email).to eql('alice@example.com')
        expect(User.count).to eql(1)
      end
    end
    
    context 'when user does not exist' do
      let(:assessor_role) { Role.find_by_name('Assessor') }

      it 'should create user from auth hash' do
        expect(user.uid).to eql(auth_details[:uid])
        expect(user.name).to eql(auth_details[:info][:name])
        expect(user.email).to eql(auth_details[:info][:email])
        expect(User.count).to eql(1)
      end

      its(:roles) { should include(assessor_role) }
    end
  end
end
