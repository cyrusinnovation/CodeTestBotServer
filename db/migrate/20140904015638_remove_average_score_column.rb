class RemoveAverageScoreColumn < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.remove :average_score
    end
  end
end
