class SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :candidate_name, :candidate_email, :email_text, :zipfile, :created_at, :updated_at, :active, :average_score
  has_one :language
  has_one :level
  has_many :assessments
end
