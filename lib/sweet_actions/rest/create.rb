module SweetActions
  module REST
    module Create
      include Save
      include Singular

      private

      def set_resource
        resource_class.new(resource_params)
      end
    end
  end
end
