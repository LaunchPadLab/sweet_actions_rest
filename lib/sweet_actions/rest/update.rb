module SweetActions
  module REST
    module Update
      include Save
      include Find

      private

      def save
        resource.attributes = resource_params
        resource.save
      end
    end
  end
end
