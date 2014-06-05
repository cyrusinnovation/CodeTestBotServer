class Page < ActiveRecord::Base
  validates_uniqueness_of :name

  def self.update_from_json(id, page_json)
    page = find_by_name!(id)
    page.update_attribute(:raw_text, page_json[:raw_text])
    page
  end
end
