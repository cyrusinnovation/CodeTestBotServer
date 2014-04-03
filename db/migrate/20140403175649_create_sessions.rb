class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.belongs_to :user
      t.string :token
      t.datetime :token_expiry

      t.timestamps
    end

    change_table :users do |t|
      t.remove :token
    end
  end
end
