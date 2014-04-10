module CodeTestBotServer
  module Matchers
    def have_header_value(header, value)
      HaveHeaderValueMatcher.new(header, value)
    end

    class HaveHeaderValueMatcher
      def initialize(header, value)
        @header = header
        @value = value
      end

      def matches?(response)
        @response = response
        has_header? && correct_value?
      end

      def description
        "should respond with header #{@header}: #{@value}"
      end

      def failure_message
        "Expected response header #{@header} to have value #{@value}, #{failure_type}"
      end

      private

      def has_header?
        @response.headers.has_key? @header
      end

      def correct_value?
        @response.headers[@header] == @value
      end

      def failure_type
        unless has_header?
          return 'but it didn\'t exist'
        end

        "but was #{@response.headers[@header]}"
      end
    end
  end
end
