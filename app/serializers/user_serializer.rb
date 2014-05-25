class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :email, :image_url, :editable
  has_one :role
end
