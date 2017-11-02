module SweetActions
  module Rest
    module Collect
      include Read
      include Multiple

      private

      def set_resource
        resource_class.all
      end
    end
  end
end
