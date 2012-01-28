# -*- encoding: utf-8 -*-

module EnumColumn3
  module ActionViewHelpers
    def self.included(base)
      base::FormHelper.send :include, FormHelperExt
      base::FormTagHelper.send :include, FormTagHelperExt
      base::InstanceTag.send :include, InstanceTagExt

      # work-around
      ActionView::Base.send :include, FormTagHelperExt
    end

    module FormHelperExt
      def enum_select(object, method, options={}, html_options={})
        ::ActionView::Helpers::InstanceTag.new(object, method, self, options.delete(:object)).to_enum_select_tag(options, html_options)
      end
    end

    module FormTagHelperExt
      def enum_select_tag(object_name, method, options={}, html_options={})
        ::ActionView::Helpers::InstanceTag.new(object_name, method, self, nil).to_enum_select_tag(options, html_options)
      end
      alias :enum_select :enum_select_tag
    end

    module InstanceTagExt
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
    end
  end
end