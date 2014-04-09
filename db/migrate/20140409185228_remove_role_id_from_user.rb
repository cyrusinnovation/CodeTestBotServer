class RemoveRoleIdFromUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :role_id
    end
  end
end
