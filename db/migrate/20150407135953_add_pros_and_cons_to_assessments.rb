class AddProsAndConsToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :pros, :text
    add_column :assessments, :cons, :text
  end
end
