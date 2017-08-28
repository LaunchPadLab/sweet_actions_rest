module SweetActions
  class ApiAction
    attr_reader :controller, :response_data, :response_code

    def initialize(controller, options = {})
      @controller = controller
      after_init(options)
    end

    def perform_action
      run_action = Proc.new do
        @response_data = action
      end

      debug_mode? ? run_action.call : fail_gracefully(run_action)
    end

    private

    def after_init(options); end

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

    def action
      raise "action method is required for #{self.class.name} because it inherits from ApiAction"
    end

    def path_parameters
      @path_parameters ||= env['action_dispatch.request.path_parameters']
    end

    def request
      @request ||= controller.request
    end

    def params
      @params ||= controller.params
    end

    def env
      request.env
    end
  end
end
