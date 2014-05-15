class AddActiveFlagToSubmission < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.column :active, :boolean, default: true
    end
  end
end
