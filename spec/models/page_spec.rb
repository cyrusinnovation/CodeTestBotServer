require 'spec_helper'

describe Page do
  it { should respond_to(:name) }
  it { should respond_to(:raw_text) }

  describe '#name' do
    before { Page.create!({ name: 'welcome', raw_text: 'text' }) }

    it 'is unique' do
      expect { Page.create!({ name: 'welcome', raw_text: 'text2' }) }.to raise_error(ActiveRecord::RecordInvalid, /Name/)
    end
  end
end
