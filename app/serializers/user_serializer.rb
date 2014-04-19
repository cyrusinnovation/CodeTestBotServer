class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :email, :editable
  has_many :roles
end