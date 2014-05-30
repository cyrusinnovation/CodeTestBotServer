class AddAverageScoreToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :average_score, :float
  end
end
