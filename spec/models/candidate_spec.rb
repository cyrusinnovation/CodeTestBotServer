require 'spec_helper'

describe Candidate do
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:submissions) }
  it { should respond_to(:level) }

  it 'should be able reference a level' do
    junior = Level.find_by_text('Junior')
    Candidate.create({name: 'Bob', level: junior})

    expect(Candidate.first.level.text).to eql('Junior')
  end
end
