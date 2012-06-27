# -*- encoding: utf-8 -*-

module EnumColumn3
  module ActiveRecordConnectionAdapters
    def self.included(base)
      if ActiveRecord::VERSION::MAJOR == 3
        if ActiveRecord::VERSION::MINOR == 0
          base::MysqlAdapter.send :include, MysqlAdapterExt::InstanceMethods
    
          base::MysqlAdapter.class_eval do
            alias_method_chain :native_database_types, :enum
          end
    
          base::MysqlColumn.send :extend, MysqlColumnExt::ClassMethods
          base::MysqlColumn.send :include, MysqlColumnExt::InstanceMethods
    
          base::MysqlColumn.class_eval do
            alias_method_chain :klass, :enum
            alias_method_chain :type_cast, :enum
            alias_method_chain :type_cast_code, :enum
    
            alias_method_chain :simplified_type, :enum
            alias_method_chain :extract_limit, :enum
          end
        elsif ActiveRecord::VERSION::MINOR == 1
          base::Mysql2Adapter.send :include, Mysql2AdapterExt::InstanceMethods
    
          base::Mysql2Adapter.class_eval do
            alias_method_chain :native_database_types, :enum
          end
    
          base::Mysql2Column.send :extend, Mysql2ColumnExt::ClassMethods
          base::Mysql2Column.send :include, Mysql2ColumnExt::InstanceMethods
    
          base::Mysql2Column.class_eval do
            alias_method_chain :klass, :enum
            alias_method_chain :type_cast, :enum
            alias_method_chain :type_cast_code, :enum
    
            alias_method_chain :simplified_type, :enum
            alias_method_chain :extract_limit, :enum
          end
        elsif ActiveRecord::VERSION::MINOR >= 2
          # TODO
          base::Mysql2Adapter.send :include, Mysql2AdapterExt::InstanceMethods
          base::Mysql2Adapter.class_eval do
            alias_method_chain :native_database_types, :enum
          end

          base::Mysql2Adapter::Column.send :extend, Mysql2ColumnExt::ClassMethods
          base::Mysql2Adapter::Column.send :include, Mysql2ColumnExt::InstanceMethods
          base::Mysql2Adapter::Column.class_eval do
            alias_method_chain :klass, :enum
            alias_method_chain :type_cast, :enum
            alias_method_chain :type_cast_code, :enum

            alias_method_chain :simplified_type, :enum
            alias_method_chain :extract_limit, :enum
          end
        end
      end

      base::Quoting.send :include, QuotingExt::InstanceMethods

      base::Quoting.module_eval do
        alias_method_chain :quote, :enum
      end

      base::TableDefinition.send :include, TableDefinitionExt::InstanceMethods

      base::SchemaStatements.send :include, SchemaStatementsExt::InstanceMethods

      base::SchemaStatements.module_eval do
        alias_method_chain :type_to_sql, :enum
      end
    end

    module Mysql2ColumnExt
      module ClassMethods
        def value_to_symbol(value)
          case value
          when Symbol
            value
          when String
            value.empty? ? nil : value.intern
          else
            nil
          end
        end
      end
  
      module InstanceMethods
        def klass_with_enum
          if type == :enum
            Symbol
          else
            klass_without_enum
          end
        end
  
        def type_cast_with_enum(value)
          if type == :enum
            self.class.value_to_symbol(value)
          else
            type_cast_without_enum(value)
          end
        end
  
        def type_cast_code_with_enum(var_name)
          if type == :enum
            "#{self.class.name}.value_to_symbol(#{var_name})"
          else
            type_cast_code_without_enum(var_name)
          end
        end
  
  
        private
  
        def simplified_type_with_enum(field_type)
          if field_type =~ /enum/i
            :enum
          else
            simplified_type_without_enum(field_type)
          end
        end
  
        def extract_limit_with_enum(sql_type)
          if sql_type =~ /^enum/i
            sql_type.sub(/^enum\('(.+)'\)/i, '\1').split("','").map { |v| v.intern }
          else
            extract_limit_without_enum(sql_type)
          end
        end
      end
    end
    MysqlColumnExt = Mysql2ColumnExt

    module Mysql2AdapterExt
      module InstanceMethods
        def native_database_types_with_enum
          types = native_database_types_without_enum
          types[:enum] = { :name => "enum" }
          types
        end
      end
    end
    MysqlAdapterExt = Mysql2AdapterExt

    module QuotingExt
      module InstanceMethods
        def quote_with_enum(value, column = nil)
          if !value.is_a? Symbol
            quote_without_enum(value, column)
          else
            ActiveRecord::Base.send(:quote_bound_value, value.to_s)
          end
        end
      end
    end

    module TableDefinitionExt
      module InstanceMethods
        def enum(*args)
          options = args.extract_options!
          column_names = args
          column_names.each { |name| column(name, 'enum', options) }
        end
      end
    end

    module SchemaStatementsExt
      module InstanceMethods
        def type_to_sql_with_enum(type, limit = nil, precision = nil, scale = nil) #:nodoc:
          if type == :enum
            native = native_database_types[type]
            column_type_sql = (native || {})[:name] || 'enum'
  
            column_type_sql << "(#{limit.map { |v| quote(v) }.join(',')})"
  
            column_type_sql
          else
            type_to_sql_without_enum(type, limit, precision, scale)
          end
        end
      end
    end
  end
end
