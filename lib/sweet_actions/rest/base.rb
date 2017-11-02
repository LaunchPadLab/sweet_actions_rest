module SweetActions
  module REST
    module Base
      include AuthorizationConcerns
      include REST::Resource
    end
  end
end