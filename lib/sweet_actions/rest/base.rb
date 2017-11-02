module SweetActions
  module REST
    module Base
      include AuthorizationConcerns
      include Resource
    end
  end
end