class ChangeZipfile < ActiveRecord::Migration
  def up 
    change_table :submissions do |t|
      t.remove :zipfile_file_name
      t.remove :zipfile_content_type
      t.remove :zipfile_file_size
      t.remove :zipfile_updated_at
      t.column :zipfile, :string
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
