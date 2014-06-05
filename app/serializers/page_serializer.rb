class PageSerializer < ActiveModel::Serializer
  attributes :id, :name, :raw_text

  def id
    object.name
  end
end
