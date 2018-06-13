require 'active_support/all'
require 'sweet_actions'
require 'decanter'
require 'active_model_serializers'

module SweetActionsRest
  class << self
    def configuration
      @config ||= SweetActionsRest::Configuration.new
    end

    def config
      yield configuration
    end
  end

  ActiveSupport.run_load_hooks(:sweet_actions_rest, self)
end

# overhead
require 'sweet_actions_rest/version'
require 'sweet_actions_rest/configuration'
require 'sweet_actions_rest/exceptions'

# concerns
require 'sweet_actions_rest/authorization'
require 'sweet_actions_rest/resource'
require 'sweet_actions_rest/serialize'

# json concerns
require 'sweet_actions_rest/json/concerns/write'
require 'sweet_actions_rest/json/concerns/singular'
require 'sweet_actions_rest/json/concerns/multiple'

# json actions
require 'sweet_actions_rest/json/base_action'
require 'sweet_actions_rest/json/create_action'
require 'sweet_actions_rest/json/destroy_action'
require 'sweet_actions_rest/json/index_action'
require 'sweet_actions_rest/json/show_action'
require 'sweet_actions_rest/json/update_action'
