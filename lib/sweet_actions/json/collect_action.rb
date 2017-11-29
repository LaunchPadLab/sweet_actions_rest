module SweetActions
  module JSON
    class CollectAction < BaseAction
      include REST::Collect

      private

      def respond
        serialize
      end
    end
  end
end
