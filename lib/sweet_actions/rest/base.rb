module SweetActions
  module Rest
    module Base
      include AuthorizationConcerns
      include Rest::Resource
    end
  end
end