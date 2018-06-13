module SweetActionsRest
  module JSON
    class DestroyAction < BaseAction
      include Concerns::Singular

      def action
        @resource = find_resource
        authorize
        destroy
        respond
      end

      private

      def destroy
        resource.destroy
      end

      def respond
        serialize
      end

      def find_resource
        resource_class.find(params[:id])
      end
    end
  end
end
