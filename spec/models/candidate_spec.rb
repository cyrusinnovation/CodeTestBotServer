require 'spec_helper'

describe Candidate do
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:submissions) }
end
