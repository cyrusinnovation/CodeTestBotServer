class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name

      t.timestamps
    end

    change_table :submissions do |t|
      t.belongs_to :language
    end
  end
end
