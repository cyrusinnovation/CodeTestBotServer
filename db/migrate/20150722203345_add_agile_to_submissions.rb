class AddAgileToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :agile, :text
  end
end
