require 'test_helper'

describe Twofishes::Client do

  it "should geocode" do
    mock_response(200, interpretations: [])

    Twofishes::Client.geocode('Zurich')
  end

  it "should reverse geocode" do
    mock_response(200, interpretations: [])

    Twofishes::Client.reverse_geocode([0, 0])
  end

  it "should call api" do
    mock_response(200, interpretations: [])

    Twofishes::Client.call_api({query: 'zurich'})
  end

  it "should raise an error" do
    mock_response(500, exception: 'java.lang.NumberFormatException: For input string: ""')

    assert_raises Twofishes::ServerInternalError do
      Twofishes::Client.call_api({})
    end
  end

end