require 'spec_helper'

describe PagesController do
  describe '#show' do
    let(:page) { Page.create!({name: 'test', raw_text: 'wecome!' }) }
    let(:page_json) { {page: { name: page.name, raw_text: page.raw_text }}.to_json }

    subject { get :show, {id: 'test'} }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

      it { should be_ok }
      its(:body) { should be_json_eql(page_json) }
    end
  end

  describe '#update' do
    let(:page_id) { 'test' }
    before { Page.create!({name: 'test', raw_text: 'original' }) }

    subject { put :update, { id: page_id, page: { raw_text: 'updated' } } }

    it_behaves_like 'a secured route'

    context 'when user is unauthorized' do
      before { add_user_to_session('Assessor') }

      it { should be_forbidden }
    end

    context 'when user is administrator' do
      before { add_user_to_session('Administrator') }

      context 'when updating an existing page' do
        let(:expected_json) { { name: 'test', raw_text: 'updated' }.to_json }

        it { should be_ok }
        its(:body) { should be_json_eql(expected_json).at_path('page') }
        it 'should update the page' do
          subject

          expect(Page.find_by_name(page_id).raw_text).to eq('updated')
        end
      end

      context 'when update a page that does not exist' do
        let(:page_id) { 'not_existing' }
        it { should be_not_found }
      end
    end
  end
end
