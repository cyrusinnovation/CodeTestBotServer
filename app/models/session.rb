class Session < ActiveRecord::Base
  belongs_to :user

  def expired?
    Time.now.utc >= token_expiry
  end
end
