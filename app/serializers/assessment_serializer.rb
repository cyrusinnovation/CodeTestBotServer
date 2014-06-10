class AssessmentSerializer < ActiveModel::Serializer
  attributes :id, :score, :notes, :created_at, :submission_id
  has_one :assessor
end