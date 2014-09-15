class AddExemplaryFlagAndChangeScoreScale < ActiveRecord::Migration
  def change
    change_table :assessments do |t|
      t.column :exemplary, :boolean, default: false
    end

    Assessment.connection.execute("UPDATE assessments SET exemplary='t' WHERE score = 5")
    Assessment.connection.execute("UPDATE assessments SET score = 0 WHERE score IS NULL")
    # Somewhat crude rescaling of scores:
    # 1 == No
    # 2 == Maybe
    # 3 == Yes
    Assessment.connection.execute("UPDATE assessments SET score = (CASE WHEN score <= 2 THEN 1 WHEN score = 3 THEN 2 WHEN score >= 3 THEN 3 END)")
  end
end
