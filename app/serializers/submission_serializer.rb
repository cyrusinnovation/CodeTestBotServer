class SubmissionSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :candidate_name, :candidate_email, :email_text, :zipfile, :created_at, :updated_at, :active, :average_score, :source, :resumefile, :github
  has_one :language
  has_one :level

  private

  def average_score
    object.average_score if object.respond_to?(:average_score)
  end
end
