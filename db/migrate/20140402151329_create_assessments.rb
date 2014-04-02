class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.belongs_to :submission
      t.belongs_to :assessor
      t.integer :score
      t.text :notes

      t.timestamps
    end
  end
end
