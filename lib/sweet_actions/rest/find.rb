module SweetActions
  module REST
    module Find
      include Singular

      private

      def set_resource
        resource_class.find(params[:id])
      end
    end
  end
end