# -*- encoding: utf-8 -*-

module EnumColumn3
  class Railtie < ::Rails::Railtie
    def self.initialize!
      unless @initialized
        Rails::Generators.send :include, EnumColumn3::RailsGenerators
    
        ActiveSupport.on_load :active_record do
          ActiveRecord::ConnectionAdapters.send :include, EnumColumn3::ActiveRecordConnectionAdapters
          ActiveRecord::Base.send :include, EnumColumn3::ActiveRecordValidations
        end
        ActiveSupport.on_load :action_view do
          ActionView::Helpers.send :include, EnumColumn3::ActionViewHelpers
        end
      end
      @initialized = true
    end

    initializer 'enum_column3.initialize', :after => 'active_record.initialize_database' do |app|
      EnumColumn3::Railtie.initialize!
    end
  end
end