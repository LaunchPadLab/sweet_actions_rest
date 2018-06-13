module SweetActionsRest
  module JSON
    module Concerns
      module Singular
        def root_key
          singular_key
        end
      end
    end
  end
end
