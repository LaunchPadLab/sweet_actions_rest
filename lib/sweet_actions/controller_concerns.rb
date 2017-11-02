module SweetActions
  module ControllerConcerns
    def action_missing(action_name)
      factory = ActionFactory.new(self, action_name)
      action = factory.build_action
      action.perform_action
    end
  end
end