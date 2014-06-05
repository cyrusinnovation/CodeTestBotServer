require 'spec_helper'

describe PagesController do
  describe '#show' do
    let(:page) { Page.create!({name: 'test', raw_text: 'wecome!' }) }
    let(:page_json) { {page: { name: page.name, raw_text: page.raw_text }}.to_json }

    subject { get :show, {id: 'test'} }

    it { should be_ok }
    its(:body) { should be_json_eql(page_json) }
  end
end
