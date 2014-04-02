class CandidateSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :name, :email
  has_one :level
end
