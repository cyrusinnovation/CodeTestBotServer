class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :raw_text

      t.timestamps
    end

    Page.create!({ name: 'welcome', raw_text: 'Edit this page.' })
  end
end
