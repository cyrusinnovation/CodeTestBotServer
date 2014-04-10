module CodeTestBotServer
  module Matchers
    def match_json(value, path)
      MatchJSONMatcher.new(value, path)
    end

    class MatchJSONMatcher
      include JsonSpec::Helpers

      def initialize(value, path)
        @value = value
        @path = path
      end

      def matches?(response)
        @response = response
        @result = parse_json(response.body, @path)
        @result == @value
      end

      def description
        'should match JSON at path'
      end

      def failure_message
        "Expected value #{@value} at path #{@path}, but was #{@result}"
      end
    end
  end
end