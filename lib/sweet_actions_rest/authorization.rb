module SweetActionsRest
  module Authorization
    private

    def authorize?
      SweetActionsRest.configuration.authorize_rest_requests
    end

    def authorize
      return unless authorize?
      return true if authorized?
      unauthorized
    end

    def authorized?
      false # lock it down by default
    end

    def unauthorized
      raise Exceptions::NotAuthorized
    end
  end
end