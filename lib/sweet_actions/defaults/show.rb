module SweetActions
  module Defaults
    class Show < ShowAction
      def set_resource
        resource_class.find(params[:id])
      end

      def authorized?
        true
      end
    end
  end
end
