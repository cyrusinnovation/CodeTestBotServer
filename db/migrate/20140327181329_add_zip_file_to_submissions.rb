class AddZipFileToSubmissions < ActiveRecord::Migration
  def self.up
    add_attachment :submissions, :zipfile
  end

  def self.down
    remove_attachment :submissions, :zipfile
  end
end
