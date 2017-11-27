module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller

      def adapter(&block)
        klass = admin.adapter
        klass.instance_eval(&block) if block_given?
        klass
      end

      def adapter=(adapter)
        admin.adapter = adapter
      end

      def remove_action(*actions)
        actions.each do |action|
          controller.remove_possible_method(action.to_sym)
          admin.actions.delete(action.to_sym)
        end
      end

      def collection(&block)
        admin.collection = block
      end

      def find_instance(&block)
        admin.find_instance = block
      end
      alias instance find_instance

      def build_instance(&block)
        admin.build_instance = block
      end

      def update_instance(&block)
        admin.update_instance = block
      end

      def save_instance(&block)
        admin.save_instance = block
      end

      def delete_instance(&block)
        admin.delete_instance = block
      end

      def to_param(&block)
        admin.to_param = block
      end

      def params(&block)
        admin.permitted_params = block
      end

      def decorator(decorator)
        admin.decorator = decorator
      end

      def decorate_collection(&block)
        admin.decorate_collection = block
      end

      def merge_scopes(&block)
        admin.merge_scopes = block
      end

      def sort(&block)
        admin.sort = block
      end

      def sort_column(column, &block)
        admin.column_sorts[column.to_sym] = block
      end

      def paginate(&block)
        admin.paginate = block
      end

      def count(&block)
        admin.count = block
      end

      def scope(name, scope=nil, options={}, &block)
        if scope.is_a?(Hash)
          options = scope
          scope = nil
        end

        admin.scopes[name] = Scope.new(admin, name, options, &(scope || block))
      end

      def return_to(options={}, &block)
        actions = options.key?(:on) ? Array(options[:on]) : [:create, :update, :destroy]

        actions.each do |action|
          admin.return_locations[action.to_sym] = block
        end
      end
    end
  end
end
