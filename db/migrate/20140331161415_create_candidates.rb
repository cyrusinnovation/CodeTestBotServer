class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    change_table :submissions do |t|
      t.belongs_to :candidate
    end
  end
end
