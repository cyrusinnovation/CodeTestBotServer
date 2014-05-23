require 'net/http'

module Notifications
  class Submissions
    class WebHooks < SlackWebHook
      def self.new_submission(submission)
        if Figaro.env.slack_webhook?
          post(URI(Figaro.env.slack_webhook), make_payload(submission))
        end
      end

      private

      def self.make_payload(submission)
        submission_url = "#{Figaro.env.app_uri}/submissions/#{submission.id}"
        message = "New Code Test Submission: <#{submission_url}|Click to view>"
        {
          username: 'Code Test Bot',
          icon_emoji: ':scream:',
          attachments: [
            {
              fallback: message,
              pretext: message,
              color: '#0000D0',
              fields: [
                { title: 'Candidate Level', value: submission.level.text, short: false },
                { title: 'Language', value: submission.language.name, short: false }
              ]
            }
          ]
        }
      end
    end
  end
end

