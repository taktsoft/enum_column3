# -*- encoding: utf-8 -*-

module EnumColumn3
  module RailsGenerators
    def self.included(base)
      base::GeneratedAttribute.send :include, InstanceMethods

      base::GeneratedAttribute.class_eval do
        alias_method_chain :field_type, :enum_attribute
      end
    end

    module InstanceMethods
      def field_type_with_enum_attribute
        if type == :enum
          @field_type = :enum_select
        else
          field_type_without_enum_attribute
        end
      end
    end
  end
end
