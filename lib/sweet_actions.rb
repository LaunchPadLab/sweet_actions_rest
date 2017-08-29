module SweetActions
  class << self
    def configuration
      @config ||= SweetActions::Configuration.new
    end

    def config
      yield configuration
    end
  end

  ActiveSupport.run_load_hooks(:sweet_actions, self)
end

# overhead
require 'sweet_actions/version'
require 'sweet_actions/configuration'
require 'sweet_actions/exceptions'

# base classes
require 'sweet_actions/action_factory'
require 'sweet_actions/api_action'

# concerns
require 'sweet_actions/rest_serializer_concerns'
require 'sweet_actions/rest_concerns'
require 'sweet_actions/authorization_concerns'
require 'sweet_actions/save_concerns'
require 'sweet_actions/read_concerns'

# actions
require 'sweet_actions/collect_action'
require 'sweet_actions/create_action'
require 'sweet_actions/update_action'
require 'sweet_actions/show_action'
require 'sweet_actions/destroy_action'

# helpers
require 'sweet_actions/controller_concerns'
require 'sweet_actions/routes_helpers'

require 'sweet_actions/railtie' if defined?(::Rails)