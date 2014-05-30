class SubmissionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :candidate_name, :candidate_email, :email_text, :zipfile, :created_at, :updated_at, :active, :average_score
  has_one :language
  has_one :level
end
