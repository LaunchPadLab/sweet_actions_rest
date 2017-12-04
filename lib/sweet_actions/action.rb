module SweetActions
  class Action
    attr_reader :controller

    def initialize(controller, options = {})
      @controller = controller
      after_init(options)
    end

    def perform_action
      action
    end

    private

    delegate :request, :params, to: :controller

    def after_init(options); end

    def action
      raise "action method is required for #{self.class.name} because it inherits from SweetActions::Action"
    end

    def env
      request.env
    end

    def path_parameters
      @path_parameters ||= env['action_dispatch.request.path_parameters']
    end
  end
end