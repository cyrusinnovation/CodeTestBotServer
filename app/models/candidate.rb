class Candidate < ActiveRecord::Base
  has_many :submissions
  belongs_to :level
end
