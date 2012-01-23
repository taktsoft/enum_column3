# -*- encoding: utf-8 -*-

module EnumColumn3
  module ActionViewHelpers
    def self.included(base)
      base::FormOptionsHelper.send :include, FormOptionsHelper
      base::FormBuilder.send :include, FormBuilder
      base::InstanceTag.send :include, InstanceTag

      base::InstanceTag.class_eval do
        alias_method_chain :to_tag, :enum_attribute
      end
    end

    module FormOptionsHelper
      def enum_select(object, method, options={}, html_options={})
        InstanceTag.new(object, method, self, options.delete(:object)).to_enum_select_tag(options, html_options)
      end
    end

    module InstanceTag
      def to_enum_select_tag(options, html_options={})
        if self.object.respond_to?(method_name.to_sym)
          column = self.object.column_for_attribute(method_name)
          if (value = self.object.__send__(method_name.to_sym))
            options[:selected] ||= value.to_s
          else
            options[:include_blank] = column.null if options[:include_blank].nil?
          end
        end
        to_select_tag(column.limit, options, html_options)
      end

      def to_tag_with_enum_attribute(options={})
        if (column_type == :enum && self.object.class.respond_to?(method_name.to_sym))
          to_enum_select_tag(options)
        else
          to_tag_without_enum_attribute(options)
        end
      end
    end

    module FormBuilder
      def enum_select(method, options={}, html_options={})
        @template.enum_select(@object_name, method, objectify_options(options), @default_options.merge(html_options))
      end
    end
  end
end