module SweetActions
  module JSON
    class CreateAction < BaseAction
      include REST::Serialize
      include REST::Create

      private

      def respond_with_success
        serialize
      end

      def respond_with_error
        @response_code = '422'
        serialize_errors
      end
    end
  end
end
