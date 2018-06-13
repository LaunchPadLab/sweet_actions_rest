module SweetActionsRest
  module JSON
    class ShowAction < BaseAction
      include Concerns::Singular
      
      def action
        @resource = find_resource
        authorize
        respond
      end

      private
      
      def find_resource
        resource_class.find(params[:id])
      end

      def respond
        serialize
      end
    end
  end
end