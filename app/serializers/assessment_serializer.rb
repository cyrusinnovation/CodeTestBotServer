class AssessmentSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :score, :notes
  has_one :submission
  has_one :assessor
end