module SweetActions
  module JSON
    class DestroyAction < BaseAction
      include Rest::Serialize
      include Rest::Destroy

      private

      def respond
        serialize
      end
    end
  end
end
