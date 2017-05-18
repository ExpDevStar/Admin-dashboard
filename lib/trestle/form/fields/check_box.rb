module Trestle
  class Form
    module Fields
      class CheckBox < Field
        attr_reader :checked_value, :unchecked_value

        def initialize(builder, template, name, options = {}, checked_value = "1", unchecked_value = "0")
          super(builder, template, name, options)

          @checked_value, @unchecked_value = checked_value, unchecked_value
        end

        def render
          field
        end

        def field
          content_tag(:div, class: "checkbox") do
            content_tag(:label) do
              safe_join([
                builder.raw_check_box(name, options, checked_value, unchecked_value),
                options[:label] || admin.model.human_attribute_name(name)
              ], " ")
            end
          end
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:check_box, Trestle::Form::Fields::CheckBox)
