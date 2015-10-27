module Moneywire
  class ApiError < StandardError
    attr_reader :response

    def initialize(message = 'ApiError', response = nil)
      super(message)
      @response = response
    end
  end

  class BadRequestError < ApiError; end
  class AuthenticationError < ApiError; end
  class ForbiddenError < ApiError; end
  class InternalApplicationError < ApiError; end
  class NotFoundError < ApiError; end

  class UnknownError < ApiError; end
end
