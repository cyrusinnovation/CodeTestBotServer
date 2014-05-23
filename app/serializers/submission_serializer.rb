class SubmissionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :candidate_name, :candidate_email, :email_text, :zipfile, :created_at, :active
  has_one :language
  has_one :level
end
