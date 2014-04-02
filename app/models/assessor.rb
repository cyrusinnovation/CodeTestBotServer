class Assessor < User
  has_many :assessments
  has_many :submissions, through: :assessments
end