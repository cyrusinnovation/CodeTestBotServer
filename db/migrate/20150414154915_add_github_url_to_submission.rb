class AddGithubUrlToSubmission < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.column :github, :string
    end
  end
end
