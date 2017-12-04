module SweetActions
  module REST
    module Base
      include SweetActions::Authorization
      include SweetActions::Resource
    end
  end
end