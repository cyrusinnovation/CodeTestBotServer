module ApplicationHelper
  require 'kramdown'

  def markdown_to_html(markdown)
    return '' if !markdown
    Kramdown::Document.new(markdown).to_html
  end
end
