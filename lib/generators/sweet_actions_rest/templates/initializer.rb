SweetActionsRest.config do |config|
  # REST actions must implement `authorize` method
  # setting to true is the most secure
  config.authorize_rest_requests = true
end
