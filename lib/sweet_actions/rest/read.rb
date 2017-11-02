module SweetActions
  module Rest
    module Read
      include Base

      private

      def action
        @resource = set_resource
        authorize
        respond
      end

      def respond
        raise "respond method must be implemented by #{self.class.name} since it includes SweetActions::Rest::Read"
      end
    end
  end
end
