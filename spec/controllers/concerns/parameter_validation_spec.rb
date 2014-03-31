require 'spec_helper'

describe ParameterValidation do

  class Dummy
    include ParameterValidation
    attr_accessor(:params)
  end

  before(:each) do
    @dummy = Dummy.new
  end

  it 'should not raise if required parameters are present' do
    @dummy.params = {first: '', second:''}
    expect{@dummy.validate_parameters_present(:first, :second)}.not_to raise_error
  end

  it 'should raise BadRequest if any single parameter is missing' do
    @dummy.params = {second:''}
    expect{@dummy.validate_parameters_present(:first)}.to raise_error(HttpStatus::BadRequest, 'Missing required parameter: first')
  end

  it 'should raise BadRequest if multiple parameters are missing' do
    @dummy.params = {}
    expect{@dummy.validate_parameters_present(:first, :second)}.to raise_error(HttpStatus::BadRequest, 'Missing required parameters: first, second')
  end
end