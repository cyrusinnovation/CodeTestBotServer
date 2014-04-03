class SessionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :token, :token_expiry
  has_one :user

  def id
    'current'
  end
end