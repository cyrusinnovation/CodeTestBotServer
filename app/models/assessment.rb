class Assessment < ActiveRecord::Base
  belongs_to :submission
  belongs_to :assessor
end
