class AddLinkedInUrlToSubmission < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.column :linkedin, :string
    end
  end
end
