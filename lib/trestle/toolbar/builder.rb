module Trestle
  class Toolbar
    class Builder
      def initialize(template)
        @template = template
      end

      def self.builder_methods
        @builder_methods ||= []
      end

      def self.builder_method(*methods)
        builder_methods.concat(methods)
      end

      def button(content, options={})
        options[:class] = button_classes_from_options(options)

        button_tag(button_label(content, options), options)
      end

      def link(content, instance_or_url={}, options={})
        options = instance_or_url if instance_or_url.is_a?(Hash)
        options[:class] = button_classes_from_options(options)

        admin_link_to(button_label(content, options), instance_or_url, options)
      end

      builder_method :button, :link

    private
      delegate :admin_link_to, :button_tag, :content_tag, :safe_join, :icon, to: :@template

      def button_classes_from_options(options)
        classes = (options[:class] || "").split("\s")
        classes.unshift("btn-#{options.delete(:style) || "default"}")
        classes.unshift("btn") unless classes.include?("btn")
        classes
      end

      def button_label(content, options)
        icon = icon(options.delete(:icon)) if options[:icon]
        label = content_tag(:span, content, class: "btn-label")

        safe_join([icon, label].compact, " ")
      end
    end
  end
end
