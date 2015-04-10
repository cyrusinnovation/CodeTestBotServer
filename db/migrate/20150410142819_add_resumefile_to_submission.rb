class AddResumefileToSubmission < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.column :resumefile, :string
    end
  end
end
