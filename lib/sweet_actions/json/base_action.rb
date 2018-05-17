module SweetActions
  module JSON
    class BaseAction < Action
      include Serialize

      attr_reader :response_data, :response_code

      def perform_action
        run_action = Proc.new do
          before_action
          @response_data = action
        end

        debug_mode? ? run_action.call : fail_gracefully(run_action)
        controller.render status: response_code, json: response_data
      end

      private

      def fail_gracefully(proc)
        @response_code = '200'
        begin
          proc.call
        rescue Exceptions::NotAuthorized => e
          @response_code = '401'
          @response_data = {
            message: 'not authorized'
          }
        rescue StandardError => e
          @response_code = '500'
          @response_data = {
            server_error: e.message
          }
        end
      end

      def debug_mode?
        ENV['SWEET_ACTION_DEBUG_MODE'] == true
      end
    end
  end
end
