# -*- encoding: utf-8 -*-

module EnumColumn3
  module ActiveRecordConnectionAdapters
    def self.included(base)
      base::Mysql2Adapter.send :include, Mysql2Adapter::InstanceMethods

      base::Mysql2Adapter.class_eval do
        alias_method_chain :native_database_types, :enum
      end

      base::Mysql2Column.send :extend, Mysql2Column::ClassMethods
      base::Mysql2Column.send :include, Mysql2Column::InstanceMethods

      base::Mysql2Column.class_eval do
        alias_method_chain :klass, :enum
        alias_method_chain :type_cast, :enum
        alias_method_chain :type_cast_code, :enum

        alias_method_chain :simplified_type, :enum
        alias_method_chain :extract_limit, :enum
      end

      base::Quoting.send :include, Quoting::InstanceMethods

      base::Quoting.module_eval do
        alias_method_chain :quote, :enum
      end

      base::TableDefinition.send :include, TableDefinition::InstanceMethods

      base::SchemaStatements.send :include, SchemaStatements::InstanceMethods

      base::SchemaStatements.module_eval do
        alias_method_chain :type_to_sql, :enum
      end
    end

    module Mysql2Column
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

    module Mysql2Adapter
      module InstanceMethods
        def native_database_types_with_enum
          types = native_database_types_without_enum
          types[:enum] = { :name => "enum" }
          types
        end
      end
    end

    module Quoting
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

    module TableDefinition
      module InstanceMethods
        def enum(*args)
          options = args.extract_options!
          column_names = args
          column_names.each { |name| column(name, 'enum', options) }
        end
      end
    end

    module SchemaStatements
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