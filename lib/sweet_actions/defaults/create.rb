module SweetActions
  module Defaults
    class Create < CreateAction
      def set_resource
        resource_class.new(resource_params)
      end

      def authorized?
        true
      end

      def save
        resource.save
      end
    end
  end
end