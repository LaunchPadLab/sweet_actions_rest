module SweetActions
  module Defaults
    class Collect < CollectAction
      def set_resource
        resource_class.all
      end

      def authorized?
        true
      end
    end
  end
end