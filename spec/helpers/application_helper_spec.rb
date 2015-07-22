require 'spec_helper'

describe ApplicationHelper do
  describe '::markdown_to_html' do
    it 'returns the html version of markdown for an assesment' do
      markdown = "* google.com\n * yahoo.com"
      expected_html = "<ul>\n  <li>google.com</li>\n  <li>yahoo.com</li>\n</ul>\n"
      expect(helper.markdown_to_html(markdown)).to eq expected_html
    end

    it 'returns empty string if given nil' do
      expect(helper.markdown_to_html(nil)).to eq ''
    end
  end
end
