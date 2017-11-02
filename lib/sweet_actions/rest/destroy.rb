module SweetActions
  module REST
    module Destroy
      include Base
      include Find

      private

      def action
        @resource = set_resource
        authorize
        destroy
        respond
      end

      def destroy
        resource.destroy
      end

      def respond
        raise "respond method must be implemented by #{self.class.name} since it includes SweetActions::REST::Read"
      end
    end
  end
end
