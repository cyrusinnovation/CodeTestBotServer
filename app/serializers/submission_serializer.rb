class SubmissionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :email_text, :zipfile, :created_at
  has_one :language
  has_one :candidate
end
