module Trestle
  class Resource
    class Controller < Admin::Controller
      after_action :set_trestle_location_header

      def index
        self.collection = admin.prepare_collection(params)

        respond_to do |format|
          format.html
          format.json { render json: collection }
          format.js
        end
      end

      def new
        self.instance = admin.build_instance({}, params)

        respond_to do |format|
          format.html
          format.json { render json: instance }
          format.js
        end
      end

      def create
        self.instance = admin.build_instance(admin.permitted_params(params), params)

        if admin.save_instance(instance)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("success.create", default: "The %{lowercase_model_name} was successfully created.")
              redirect_to({ action: :show, id: admin.to_param(instance) }, turbolinks: false)
            end
            format.json { render json: instance, status: :created, location: { action: :show, id: admin.to_param(instance) } }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("failure.create", default: "Please correct the errors below.")
              render "new", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def show
        self.instance = admin.find_instance(params)

        respond_to do |format|
          format.html
          format.json { render json: instance }
          format.js
        end
      end

      def edit
        self.instance = admin.find_instance(params)
      end

      def update
        self.instance = admin.find_instance(params)
        admin.update_instance(instance, admin.permitted_params(params), params)

        if admin.save_instance(instance)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("success.update", default: "The %{lowercase_model_name} was successfully updated.")
              redirect_to({ action: :show, id: admin.to_param(instance) }, turbolinks: false)
            end
            format.json { render json: instance, status: :ok }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("failure.update", default: "Please correct the errors below.")
              render "show", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        self.instance = admin.find_instance(params)
        success = admin.delete_instance(instance)

        respond_to do |format|
          format.html do
            if success
              flash[:message] = flash_message("success.destroy", default: "The %{lowercase_model_name} was successfully deleted.")
              redirect_to action: :index
            else
              flash[:error] = flash_message("failure.destroy", default: "Could not delete %{lowercase_model_name}.")

              if self.instance = admin.find_instance(params)
                redirect_to action: :show, id: admin.to_param(instance)
              else
                redirect_to action: :index
              end
            end
          end
          format.json { head :no_content }
          format.js
        end
      end

    protected
      attr_accessor :collection
      helper_method :collection

      attr_accessor :instance
      helper_method :instance

      def flash_message(type, options={})
        t("trestle.flash.#{type}", options.merge(model_name: admin.model_name, lowercase_model_name: admin.model_name.downcase))
      end

      def set_trestle_location_header
        unless request.headers["X-Trestle-Dialog"]
          headers["X-Trestle-Location"] = request.path
        end
      end
    end
  end
end
