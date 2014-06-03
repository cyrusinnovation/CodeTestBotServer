class Session < ActiveRecord::Base
  belongs_to :user

  def expired?
    return false if token_expiry == nil # TODO: Curiosity: setting 0 yield nil
    Time.now.utc >= token_expiry
  end
  def reset_token_expiry!
    an_hour_from_now = Time.now.utc + 1.hour
    if token_expiry < an_hour_from_now
      self.token_expiry = an_hour_from_now
    end
  end
end
