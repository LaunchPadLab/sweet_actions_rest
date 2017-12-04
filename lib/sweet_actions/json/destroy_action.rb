module SweetActions
  module JSON
    class DestroyAction < BaseAction
      include REST::Destroy

      private

      def respond
        serialize
      end
    end
  end
end
