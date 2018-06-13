module SweetActionsRest
  module JSON
    class BaseAction < SweetActions::JSONAction
      include SweetActionsRest::Authorization
      include SweetActionsRest::Serialize
      include SweetActionsRest::Resource
    end
  end
end
