module Trestle
  class Admin
    class Builder < Trestle::Builder
      target :admin

      class_attribute :admin_class
      self.admin_class = Admin

      class_attribute :controller
      self.controller = Controller

      delegate :helper, :before_action, :after_action, :around_action, to: :@controller

      def initialize(admin)
        @admin, @controller = admin, admin.const_get(:AdminController)
      end

      def self.create(name, options={}, &block)
        # Create admin subclass
        admin = Class.new(admin_class)
        admin.options = options

        # Define a constant based on the admin name
        scope = options[:scope] || Object
        scope.const_set("#{name.to_s.camelize}Admin", admin)

        # Define admin controller class
        # This is done using class_eval rather than Class.new so that the full
        # class name and parent chain is set when Rails' inherited hooks are called.
        admin.class_eval("class AdminController < #{controller.name}; end")

        # Set a reference on the controller class to the admin class
        controller = admin.const_get(:AdminController)
        controller.instance_variable_set("@admin", admin)

        admin.build(&block)
      end

      def menu(*args, &block)
        if block_given?
          admin.menu = Navigation::Block.new(admin, &block)
        else
          menu { item(*args) }
        end
      end

      def table(name_or_options={}, options={}, &block)
        if name_or_options.is_a?(Hash)
          name, options = :index, name_or_options.reverse_merge(admin: admin, sortable: true)
        else
          name = name_or_options
        end

        admin.tables[name] = Table::Builder.build(options, &block)
      end

      def form(options={}, &block)
        admin.form = Form.new(options, &block)
      end

      def admin(&block)
        @admin.instance_eval(&block) if block_given?
        @admin
      end

      def controller(&block)
        @controller.class_eval(&block) if block_given?
        @controller
      end

      def routes(&block)
        @admin.additional_routes = block
      end

      def breadcrumb(label=nil, path=nil, &block)
        if block_given?
          @admin.breadcrumb = block
        else
          @admin.breadcrumb = -> { Breadcrumb.new(label, path) }
        end
      end
    end
  end
end
