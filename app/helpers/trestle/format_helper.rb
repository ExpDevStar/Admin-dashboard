module Trestle
  module FormatHelper
    def format_value(value, options={})
      if options.key?(:format)
        format_value_from_options(value, options)
      else
        autoformat_value(value, options)
      end
    end

    def format_value_from_options(value, options={})
      case options[:format]
      when :currency
        number_to_currency(value)
      else
        value
      end
    end

    def autoformat_value(value, options={})
      case value
      when Time, DateTime
        timestamp(value)
      when Date
        datestamp(value)
      when TrueClass, FalseClass
        status_tag(icon("fa fa-check"), :success) if value
      when NilClass
        text = options.key?(:blank) ? options[:blank] : I18n.t("admin.format.blank")
        content_tag(:span, text, class: "blank")
      when ->(value) { value.respond_to?(:id) }
        display(value)
      else
        value
      end
    end
  end
end
