require 'fileutils'
require 'geminabox'

Geminabox.data = '.gems/geminabox'
FileUtils.mkpath(Geminabox.data)

Geminabox.rubygems_proxy = true
Geminabox.allow_remote_failure = true

use Rack::Session::Pool, expire_after: 1000
use Rack::Protection

run Geminabox::Server
