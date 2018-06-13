module SweetActionsRest
  module JSON
    module Concerns
      module Multiple
        def root_key
          plural_key
        end
      end
    end
  end
end
