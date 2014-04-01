class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :text

      t.timestamps
    end

    change_table :candidates do |t|
      t.belongs_to :level
    end
  end
end
