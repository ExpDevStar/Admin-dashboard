module Trestle
  class Form
    module Fields
      class Select < Field
        attr_reader :choices, :html_options

        def initialize(builder, template, name, choices=nil, options={}, html_options={}, &block)
          super(builder, template, name, options, &block)
          @choices, @html_options = Choices.new(choices), html_options
          html_options[:class] ||= "form-control"
        end

        def field
          builder.raw_select(name, choices, options, html_options, &block)
        end

        # Allows an array of model instances (or a scope) to be
        # passed to the select field as the list of choices.
        class Choices
          include Enumerable
          alias empty? none?

          def initialize(choices)
            @choices = choices
          end

          def each
            @choices.each do |option|
              yield option_text_and_value(option)
            end
          end

        protected
          def option_text_and_value(option)
            if !option.is_a?(String) && option.respond_to?(:first) && option.respond_to?(:last)
              option = option.reject { |e| Hash === e } if Array === option
              [option.first, option.last]
            elsif option.respond_to?(:id)
              [Trestle::Display.new(option).to_s, option.id]
            else
              [option, option]
            end
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:select, Trestle::Form::Fields::Select)
