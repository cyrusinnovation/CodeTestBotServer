class AddSourceAttributeToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :source, :string
  end
end
