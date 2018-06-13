module SweetActionsRest
  class Configuration
    attr_accessor :authorize_rest_requests

    def initialize
      @authorize_rest_requests = true
    end
  end
end
