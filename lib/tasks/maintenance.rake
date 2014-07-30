namespace :maintenance do
  desc "Recalculates the average scores for all submissions"
  task recalculate_average_scores: :environment do
  	Submission.all.each do |sub|
  		sub.recalculate_average_score if !sub.active
  	end
  end
end
