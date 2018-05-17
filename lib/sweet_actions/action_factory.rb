module SweetActions
  class ActionFactory
    attr_reader :controller, :resource_name, :action, :namespace

    def initialize(controller, action_name)
      @controller = controller
      path_parameters = env['action_dispatch.request.path_parameters']
      @resource_name = path_parameters[:resource_name]
      @action = action_name
      @namespace = path_parameters[:namespace]
    end

    def build_action
      action_class.new(controller)
    end

    private

    def env
      controller.request.env
    end

    def action_class
      parts = [namespace, resource_module, action_class_name].compact
      klass_name = parts.join('::')
      return klass_name.constantize if klass_defined?(klass_name)
      path = parts.map(&:downcase).join('/')      
      raise SweetActions::Exceptions::ActionNotFound, path: path, class_name: klass_name
    end

    def resource_module
      return nil unless resource_name
      resource_name.pluralize
    end

    def action_class_name
      raise 'action is required to be passed into actionFactory' unless action.present?
      action.to_s.classify
    end

    def default_action
      modules = namespace.split('::')
      class_found = false
      klass_name = nil

      until class_found || modules.count == 0
        namespace_to_test = modules.join('::')
        target = "#{namespace_to_test}::Defaults::#{action_class_name}"
        if klass_defined?(target)
          klass_name = target
          class_found = true
        end
        modules.pop
      end
      return klass_name.constantize if klass_name.present?
      "#{action_class_name}Action".constantize
    end

    def klass_defined?(klass_name)
      klass_name.constantize
      return true
    rescue
      return false
    end
  end
end
