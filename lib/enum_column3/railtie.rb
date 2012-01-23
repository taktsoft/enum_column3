module EnumColumn3
  class Railtie < ::Rails::Railtie
    initializer 'enum_column3.initialize', :after => 'active_record.initialize_database' do |app|
      Rails::Generator.send :include, EnumColumn3::GeneratedAttribute
  
      ActiveSupport.on_load :active_record do
        ActiveRecord::ConnectionAdapters.send :include, EnumColumn3::ActiveRecordConnectionAdapters
        ActiveRecord::ConnectionAdapters.send :include, EnumColumn3::ActiveRecordValidations
      end
      ActiveSupport.on_load :action_view do
        ActionView::Helpers.send :include, EnumColumn3::ActionViewHelpers
      end
    end
  end
end