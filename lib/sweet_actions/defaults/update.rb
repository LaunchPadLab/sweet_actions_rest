module SweetActions
  module Defaults
    class Update < UpdateAction
      def set_resource
        resource_class.find(params[:id])
      end

      def authorized?
        true
      end

      def save
        resource.update_attributes(resource_params)
      end
    end
  end
end