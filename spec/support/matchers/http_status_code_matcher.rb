module CodeTestBotServer
  module Matchers
    class HttpStatusCode
      def initialize(status)
        @status = status
      end

      def matches?(target)
        if defined?(target.status)
          @target = target.status
        else
          @target = target
        end

        @target == @status
      end

      def description
        "respond with #{@status}"
      end

      def failure_message_for_should
        "expected #{@target} to be #{@status}"
      end

      def failure_message_for_should_not
        "expected #{@target} not to be #{@status}"
      end
    end

    def be_continue
      HttpStatusCode.new(100)
    end

    def be_switching_protocols
      HttpStatusCode.new(101)
    end

    def be_ok
      HttpStatusCode.new(200)
    end

    def be_created
      HttpStatusCode.new(201)
    end

    def be_accepted
      HttpStatusCode.new(202)
    end

    def be_non_authoritative_information
      HttpStatusCode.new(203)
    end

    def be_no_content
      HttpStatusCode.new(204)
    end

    def be_reset_content
      HttpStatusCode.new(205)
    end

    def be_partial_content
      HttpStatusCode.new(206)
    end

    def be_multiple_choices
      HttpStatusCode.new(300)
    end

    def be_moved_permanently
      HttpStatusCode.new(301)
    end

    def be_found
      HttpStatusCode.new(302)
    end

    def be_see_other
      HttpStatusCode.new(303)
    end

    def be_not_modified
      HttpStatusCode.new(304)
    end

    def be_use_proxy
      HttpStatusCode.new(305)
    end

    def be_bad_request
      HttpStatusCode.new(400)
    end

    def be_unauthorized
      HttpStatusCode.new(401)
    end

    def be_payment_required
      HttpStatusCode.new(402)
    end

    def be_forbidden
      HttpStatusCode.new(403)
    end

    def be_not_found
      HttpStatusCode.new(404)
    end

    def be_method_not_allowable
      HttpStatusCode.new(405)
    end

    def be_not_acceptable
      HttpStatusCode.new(406)
    end

    def be_proxy_authentication_required
      HttpStatusCode.new(407)
    end

    def be_request_timeout
      HttpStatusCode.new(408)
    end

    def be_conflict
      HttpStatusCode.new(409)
    end

    def be_gone
      HttpStatusCode.new(410)
    end

    def be_length_required
      HttpStatusCode.new(411)
    end

    def be_precondition_failed
      HttpStatusCode.new(412)
    end

    def be_request_entity_too_large
      HttpStatusCode.new(413)
    end

    def be_request_uri_too_long
      HttpStatusCode.new(414)
    end

    def be_unsupported_media_type
      HttpStatusCode.new(415)
    end

    def be_requested_range_not_satisfiable
      HttpStatusCode.new(416)
    end

    def be_expectation_failed
      HttpStatusCode.new(417)
    end

    def be_internal_server_error
      HttpStatusCode.new(500)
    end

    def be_not_implemented
      HttpStatusCode.new(501)
    end

    def be_bad_gateway
      HttpStatusCode.new(502)
    end

    def be_service_unavailable
      HttpStatusCode.new(503)
    end

    def be_gateway_timeout
      HttpStatusCode.new(504)
    end

    def be_http_version_not_supported
      HttpStatusCode.new(505)
    end
  end
end