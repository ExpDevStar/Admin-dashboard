module Trestle
  class Form
    module Fields
      module RadioButtonHelpers
        def custom?
          options[:custom] != false
        end

        def inline?
          options[:inline]
        end

        def default_wrapper_class
          if custom?
            [
              "custom-control",
              "custom-radio",
              ("custom-control-inline" if inline?)
            ].compact
          else
            [
              "form-check",
              ("form-check-inline" if inline?)
          ].compact
          end
        end

        def input_class
          custom? ? ["custom-control-input"] : ["form-check-input"]
        end

        def label_class
          custom? ? ["custom-control-label"] : ["form-check-label"]
        end
      end
    end
  end
end
