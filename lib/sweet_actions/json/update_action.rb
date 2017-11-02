module SweetActions
  module JSON
    class UpdateAction < BaseAction
      include Rest::Serialize
      include Rest::Update

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