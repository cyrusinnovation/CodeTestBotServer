module ParameterValidation
  extend ActiveSupport::Concern

  def validate_parameters_present(*names)
    missing = names - params.keys
    message = "Missing required #{'parameter'.pluralize(missing.length)}: #{missing.join(', ')}"
    raise HttpStatus::BadRequest.new message unless missing.empty?
  end
end