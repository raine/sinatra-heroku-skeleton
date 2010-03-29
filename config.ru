require 'app'
require 'erubis'

use Rack::Static, :urls => ["/images"], :root => "public"
run Sinatra::Application
