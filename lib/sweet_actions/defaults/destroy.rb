module SweetActions
  module Defaults
    class Destroy < DestroyAction
      def destroyed_object
        object = resource_class.find(params[:id])
        object.destroy
        object
      end
    end
  end
end