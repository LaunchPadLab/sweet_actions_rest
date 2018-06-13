module SweetActionsRest
  module JSON
    class UpdateAction < BaseAction
      include Concerns::Singular
      include Concerns::Write

      def action
        @resource = find_resource
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
      
      def find_resource
        resource_class.find(params[:id])
      end

      def save
        resource.attributes = resource_params
        resource.save
      end      

      def respond_with_success
        serialize
      end

      def respond_with_failure
        @response_code = '422'
        serialize_errors
      end
    end
  end
end