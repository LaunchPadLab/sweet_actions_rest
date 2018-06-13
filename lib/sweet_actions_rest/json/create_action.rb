module SweetActionsRest
  module JSON
    class CreateAction < BaseAction
      include Concerns::Write

      def action
        @resource = build_resource
        authorize
        if validate_and_save
          after_save
          respond_with_success
        else
          after_fail
          respond_with_failure
        end
      end

      private

      def build_resource
        resource_class.new(resource_params)
      end      

      def respond_with_success
        serialize
      end

      def respond_with_failures
        @response_code = '422'
        serialize_errors
      end
    end
  end
end
