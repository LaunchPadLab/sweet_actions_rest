module SweetActions
  module JSON
    class ShowAction < BaseAction
      include Rest::Serialize
      include Rest::Show

      private

      def respond
        serialize
      end
    end
  end
end