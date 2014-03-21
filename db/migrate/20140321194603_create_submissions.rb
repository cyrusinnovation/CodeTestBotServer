class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :email_text

      t.timestamps
    end
  end
end
