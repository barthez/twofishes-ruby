module Twofishes
  BaseError = Class.new(StandardError)
  InvalidResponseError = Class.new(BaseError)

  class ServerInternalError < InvalidResponseError
    attr_reader :original_exception, :original_backtrace

    def initialize(message = nil, original_exception = nil, original_backtrace = [])
      super(message)
      @original_exception = original_exception
      @original_backtrace = original_backtrace
      if String === @original_backtrace
        @original_backtrace = @original_backtrace.each_line.map(&:strip).reject(&:empty?)
      end
    end

    def message
      "#{super} (#{original_exception})"
    end
  end

  UrlQueryError = Class.new(ServerInternalError)
  WrongParamsError = Class.new(ServerInternalError)
end
