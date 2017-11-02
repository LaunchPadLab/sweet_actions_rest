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
require 'sweet_actions/action'

# concerns
require 'sweet_actions/authorization_concerns'

# rest
require 'sweet_actions/rest/resource'
require 'sweet_actions/rest/base'
require 'sweet_actions/rest/singular'
require 'sweet_actions/rest/multiple'
require 'sweet_actions/rest/find'
require 'sweet_actions/rest/serialize'
require 'sweet_actions/rest/save'
require 'sweet_actions/rest/read'
require 'sweet_actions/rest/collect'
require 'sweet_actions/rest/create'
require 'sweet_actions/rest/update'
require 'sweet_actions/rest/show'
require 'sweet_actions/rest/destroy'

# json
require 'sweet_actions/json/base_action'
require 'sweet_actions/json/collect_action'
require 'sweet_actions/json/create_action'
require 'sweet_actions/json/update_action'
require 'sweet_actions/json/show_action'
require 'sweet_actions/json/destroy_action'

# helpers
require 'sweet_actions/controller_concerns'
require 'sweet_actions/routes_helpers'

require 'sweet_actions/railtie' if defined?(::Rails)