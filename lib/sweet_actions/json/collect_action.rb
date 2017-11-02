module SweetActions
  module JSON
    class CollectAction < BaseAction
      include Rest::Serialize
      include Rest::Collect

      private

      def respond
        serialize
      end
    end
  end
end
