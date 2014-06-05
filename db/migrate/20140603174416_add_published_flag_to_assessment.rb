class AddPublishedFlagToAssessment < ActiveRecord::Migration
  def change
    change_table :assessments do |t|
      t.column :published, :boolean, default: true
    end
  end
end
