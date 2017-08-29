module SweetActions
  module AuthorizationConcerns
    private

    def authorize?
      SweetActions.configuration.authorize_rest_requests
    end

    def authorize
      return unless authorize?
      return true if authorized?
      unauthorized
    end

    def authorized?
      raise "authorized? method is required for the #{self.class.name} action"
    end

    def unauthorized
      raise Exceptions::NotAuthorized
    end
  end
end