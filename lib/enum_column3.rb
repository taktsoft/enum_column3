# -*- encoding: utf-8 -*-

require 'rubygems'

require 'rails'
require 'rails/generators'
require 'rails/generators/generated_attribute'

if ActiveRecord::VERSION::MAJOR == 3
  if ActiveRecord::VERSION::MINOR == 0
    require 'active_record/connection_adapters/mysql_adapter'
  else
    require 'active_record/connection_adapters/mysql2_adapter'
  end
end

require 'enum_column3/action_view_helpers'
require 'enum_column3/active_record_connection_adapters'
require 'enum_column3/active_record_validations'
require 'enum_column3/rails_generators'
require 'enum_column3/railtie'
require 'enum_column3/version'
