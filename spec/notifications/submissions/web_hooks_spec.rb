require 'spec_helper'

describe Notifications::Submissions::WebHooks do
  describe '.new_submission' do
    let(:submission) { Submission.new({ id: 1, level: Level.new(text: 'Junior'), language: Language.new(name: 'Java') }) }
    before {
      Figaro.env.stub(:app_uri => 'https://example.com')
      Figaro.env.stub(:slack_webhook => 'https://fake.slack.com/webhook')
      FakeWeb.register_uri(:post, Figaro.env.slack_webhook, :body => '')
    }

    it 'posts to the webhook URI' do
      request = fire_hook
      expect(request.uri).to eq(URI(Figaro.env.slack_webhook))
    end

    describe 'POST request payload' do
      subject(:payload) { JSON.parse(fire_hook.body) }

      its(['username']) { should eq('Code Test Bot') }
      its(['icon_emoji']) { should eq(':scream:') }

      describe 'attachment' do
        let(:expected_uri) { "#{Figaro.env.app_uri}/submissions/#{submission.id}" }
        let(:expected_msg) { "New Code Test Submission: <#{expected_uri}|Click to view>" }
        subject(:attachment) { payload['attachments'][0] }

        its(['fallback']) { should eq(expected_msg) }
        its(['pretext']) { should eq(expected_msg) }
        its(['color']) { should eq('#0000D0') }

        describe 'fields' do
          subject { attachment['fields'] }

          it { should have(2).elements }
          its([0]) { should eq({ 'title' => 'Candidate Level', 'value' => 'Junior', 'short' => false }) }
          its([1]) { should eq({ 'title' => 'Language', 'value' => 'Java', 'short' => false }) }
        end
      end
    end

    def fire_hook
      Notifications::Submissions::WebHooks.new_submission(submission)
      FakeWeb.last_request
    end
  end
end
