class AddTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :password
      t.column :uid, :string
      t.column :token, :string
    end
  end
end
