module SweetActionsRest
  module JSON
    class IndexAction < BaseAction
      include Concerns::Multiple

      def action
        @resource = query_resource
        authorize
        respond
      end
      
      private
      
      def query_resource
        resource_class.all
      end

      def respond
        serialize
      end
    end
  end
end
