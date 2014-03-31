module URIValidation
  extend ActiveSupport::Concern

  def matches_protocol?(uri, *allowed)
    allowed.collect {|p| PROTOCOLS[p] }.include? uri.class
  end

  private

  PROTOCOLS = {
      :http => URI::HTTP,
      :https => URI::HTTPS
  }
end