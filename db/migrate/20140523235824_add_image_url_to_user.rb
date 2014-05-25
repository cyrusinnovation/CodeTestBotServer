class AddImageUrlToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.column :image_url, :string
    end
  end
end
