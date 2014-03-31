module HttpStatus
  class ClientError < RuntimeError
    attr_accessor(:status, :message)

    def initialize(status, message)
      self.status = status
      self.message = message
      super(message)
    end
  end

  class BadRequest < ClientError
    def initialize(message)
      super(400, message)
    end
  end
end