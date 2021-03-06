require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { :record => :once }
  config.allow_http_connections_when_no_cassette = false
end