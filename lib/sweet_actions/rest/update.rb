module SweetActions
  module Rest
    module Update
      include Find
      include Save

      private

      def save
        resource.attributes = resource_params
        resource.save
      end
    end
  end
end
