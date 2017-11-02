module SweetActions
  module Rest
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
        raise "respond method must be implemented by #{self.class.name} since it includes SweetActions::Rest::Read"
      end
    end
  end
end
