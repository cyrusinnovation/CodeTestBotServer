require 'spec_helper'

describe User do
  it 'should do a db' do
    User.create(name: 'Stuart', email: 'schilds@cyrusinnovation.com', password: 'hashmeordie')

    users = User.all
    expect(users.count).to eq(1)
  end
end
