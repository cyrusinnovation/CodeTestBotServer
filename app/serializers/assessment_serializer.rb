class AssessmentSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :score, :exemplary, :notes, :published, :created_at, :updated_at
  has_one :submission
  has_one :assessor
end
