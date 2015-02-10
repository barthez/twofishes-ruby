require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'twofishes'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'
require 'mocha/mini_test'
require 'webmock/minitest'

WebMock.disable_net_connect!(:allow => "codeclimate.com")

class MiniTest::Spec

  before do
    WebMock.reset!
  end

  def mock_response(status, body)
    stub_request(:get, %r{localhost:8081}).to_return(:status => status, :body => body.to_json, :headers => {'Content-Type' => 'application/json'})
  end
end