require 'test_helper'

describe Twofishes::BaseError do

  it "should raise InvalidResponseError" do
    mock_response(500, {})

    assert_raises Twofishes::InvalidResponseError do
      Twofishes::Client.geocode("Zurich")
    end
  end

  it "should raise ServerInternalError" do
    mock_response(500, {exception: "java.lang.Exception: too many tokens"})

    assert_raises Twofishes::ServerInternalError do
      Twofishes::Client.geocode("Zurich")
    end
  end

  it "should wrap original java exception" do
    mock_response(500, exception: "java.lang.Exception: too many tokens", stacktrace: "com.foursquare.twofishes.QueryParser.parseQueryTokens(QueryParser.scala:52)\ncom.foursquare.twofishes.QueryParser.parseQuery(QueryParser.scala:22)\n")

    begin
      Twofishes::Client.geocode("Zurich")
    rescue => ex
      assert_kind_of Twofishes::ServerInternalError, ex
      assert_equal "too many tokens", ex.to_s
      assert_equal "java.lang.Exception", ex.original_exception
      assert_equal ["com.foursquare.twofishes.QueryParser.parseQueryTokens(QueryParser.scala:52)", "com.foursquare.twofishes.QueryParser.parseQuery(QueryParser.scala:22)"], ex.original_backtrace
    end
  end

  it "should raise UrlQueryError" do
    mock_response(500, {exception: "java.lang.Exception: don't support url queries"})

    assert_raises Twofishes::UrlQueryError do
      Twofishes::Client.geocode("http://google.com")
    end
  end

  it "should raise WrongParamsError" do
    mock_response(500, {exception: "java.lang.Exception: both bounds and ll+radius, can't pick"})

    assert_raises Twofishes::WrongParamsError do
      Twofishes::Client.call_api({})
    end
  end

  it "should raise WrongParamsError" do
    mock_response(500, {exception: "java.lang.Exception: no bounds or ll"})

    assert_raises Twofishes::WrongParamsError do
      Twofishes::Client.call_api({})
    end
  end

  it "should be a Twofishes::Error" do
    assert Twofishes::ServerInternalError.new.kind_of?(Twofishes::BaseError)
    assert Twofishes::InvalidResponseError.new.kind_of?(Twofishes::BaseError)
    assert Twofishes::BaseError.new.kind_of?(StandardError)
  end

end