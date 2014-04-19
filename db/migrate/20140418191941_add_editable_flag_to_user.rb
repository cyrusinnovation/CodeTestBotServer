class AddEditableFlagToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.column :editable, :boolean, default: true
    end
  end
end
