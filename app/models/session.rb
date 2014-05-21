class Session < ActiveRecord::Base
  belongs_to :user

  def expired?
    return false if token_expiry == nil # TODO: Curiosity: setting 0 yield nil
    Time.now.utc >= token_expiry
  end
  def reset_token_expiry!
    if token_expiry < (Time.now.utc + 15.minutes)
      self.token_expiry = Time.now.utc + 15.minutes
    end
  end
end
