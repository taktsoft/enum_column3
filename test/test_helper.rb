$TEST_ROOT = File.expand_path(File.dirname(__FILE__))
$GEM_ROOT = File.expand_path(File.join($TEST_ROOT, '..', 'lib'))

$LOAD_PATH.insert(0, $GEM_ROOT)
$LOAD_PATH.insert(0, $TEST_ROOT)

$RAILS_VERSION = ENV['RAILS_VERSION'] || '3.1.3' # one of the latest rails 3 minor releases: 3.0.11, 3.1.3, 3.2.0
$DATABASE_URL= ENV['DATABASE_URL'] || 'mysql2://root:root@localhost/enum_column3'
$DATABASE_CONFIG = {}
if $DATABASE_URL =~ /^(.+)\:\/\/(.+)\@(.+)\/(.+)$/
  adapter = $1
  username = $2
  host = $3
  database = $4
  $DATABASE_CONFIG[:adapter] = adapter
  if username.include?(':')
    $DATABASE_CONFIG[:username] = username.split(':', 2).first
    $DATABASE_CONFIG[:password] = username.split(':', 2).last
  else
    $DATABASE_CONFIG[:username] = username
  end
  $DATABASE_CONFIG[:host] = host
  $DATABASE_CONFIG[:database] = database
end

puts "Using Rails-Version: #{$RAILS_VERSION}"
puts "Using Database-URL: #{$DATABASE_URL}"
puts "Using Database-Config: #{$DATABASE_CONFIG.inspect}"

require 'rubygems'

gem 'rails', $RAILS_VERSION

require 'rails/all'
Rails.env = 'test'

require 'enum_column3'

ActiveRecord::Base.establish_connection($DATABASE_CONFIG)
EnumColumn3::Railtie.initialize!

require 'schema'

require 'models'
require 'views'

require 'test/unit'
require 'pry'
