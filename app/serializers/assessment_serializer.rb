class AssessmentSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :score, :exemplary, :notes, :pros, :cons, :published, :created_at, :updated_at, :submission_id
  has_one :assessor
end
