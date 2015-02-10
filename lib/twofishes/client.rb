require 'httparty'

module Twofishes
  class Client
    # @see https://github.com/foursquare/twofishes/blob/master/docs/twofishes_requests.md

    include HTTParty
    # debug_output $stderr # httparty debugging

    # Geocodes a given string.
    #
    # @param [String] query
    # @return [Twofishes::Result]
    #
    # @example
    #     Twofishes::Client.geocode('Zurich, Switzerland')
    #
    def self.geocode(location)
      call_api(query: location)
    end

    # Reverse geocodes lat/lng.
    #
    # @param [Float] lat
    # @param [Float] lng
    # @return [Twofishes::Result]
    #
    # @example
    #     Twofishes::Client.reverse_geocode(47.3787733, 8.5273363)
    #
    def self.reverse_geocode(coordinates)
      call_api(ll: coordinates.join(','))
    end

    def self.call_api(params)
      handle_response do
        get(Twofishes.configuration.base_url, query: params, timeout: Twofishes.configuration.timeout)
      end
    end

    private

    def self.handle_response
      response = yield
      if response.code == 200
        Result.from_response(response)
      elsif response.respond_to?(:has_key?) && response.has_key?("exception")
        exception, message = response["exception"].split(/:\s+/, 2)
        raise_specific_exception(message, exception, response["stacktrace"])
      else
        raise InvalidResponseError
      end
    end

    def self.raise_specific_exception(message, exception, backtrace)
      case message
      when "don't support url queries" then raise UrlQueryError.new(message, exception, backtrace)
      when /^(both bounds and ll\+radius, can't pick|no bounds or ll)$/ then raise WrongParamsError.new(message, exception, backtrace)
      else raise ServerInternalError.new(message, exception, backtrace)
      end
    end
  end
end
